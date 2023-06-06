/*
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "cpp/dynamiccolor/material_dynamic_colors.h"

#include <cmath>

#include "cpp/cam/cam.h"
#include "cpp/cam/hct.h"
#include "cpp/cam/viewing_conditions.h"
#include "cpp/dislike/dislike.h"
#include "cpp/dynamiccolor/dynamic_color.h"
#include "cpp/dynamiccolor/tone_delta_constraint.h"
#include "cpp/scheme/dynamic_scheme.h"
#include "cpp/scheme/variant.h"
#include "cpp/utils/utils.h"

namespace material_color_utilities {

bool IsFidelity(const DynamicScheme& scheme) {
  return scheme.variant == Variant::kFidelity ||
         scheme.variant == Variant::kContent;
}

bool IsMonochrome(const DynamicScheme& scheme) {
  return scheme.variant == Variant::kMonochrome;
}

Vec3 XyzInViewingConditions(Cam cam, ViewingConditions viewing_conditions) {
  double alpha = (cam.chroma == 0.0 || cam.j == 0.0)
                     ? 0.0
                     : cam.chroma / sqrt(cam.j / 100.0);

  double t = pow(
      alpha / pow(1.64 - pow(0.29,
                             viewing_conditions.background_y_to_white_point_y),
                  0.73),
      1.0 / 0.9);
  double h_rad = cam.hue * M_PI / 180.0;

  double e_hue = 0.25 * (cos(h_rad + 2.0) + 3.8);
  double ac =
      viewing_conditions.aw *
      pow(cam.j / 100.0, 1.0 / viewing_conditions.c / viewing_conditions.z);
  double p1 = e_hue * (50000.0 / 13.0) * viewing_conditions.n_c *
              viewing_conditions.ncb;

  double p2 = (ac / viewing_conditions.nbb);

  double h_sin = sin(h_rad);
  double h_cos = cos(h_rad);

  double gamma = 23.0 * (p2 + 0.305) * t /
                 (23.0 * p1 + 11 * t * h_cos + 108.0 * t * h_sin);
  double a = gamma * h_cos;
  double b = gamma * h_sin;
  double r_a = (460.0 * p2 + 451.0 * a + 288.0 * b) / 1403.0;
  double g_a = (460.0 * p2 - 891.0 * a - 261.0 * b) / 1403.0;
  double b_a = (460.0 * p2 - 220.0 * a - 6300.0 * b) / 1403.0;

  double r_c_base = fmax(0, (27.13 * fabs(r_a)) / (400.0 - fabs(r_a)));
  double r_c =
      Signum(r_a) * (100.0 / viewing_conditions.fl) * pow(r_c_base, 1.0 / 0.42);
  double g_c_base = fmax(0, (27.13 * fabs(g_a)) / (400.0 - fabs(g_a)));
  double g_c =
      Signum(g_a) * (100.0 / viewing_conditions.fl) * pow(g_c_base, 1.0 / 0.42);
  double b_c_base = fmax(0, (27.13 * fabs(b_a)) / (400.0 - fabs(b_a)));
  double b_c =
      Signum(b_a) * (100.0 / viewing_conditions.fl) * pow(b_c_base, 1.0 / 0.42);
  double r_f = r_c / viewing_conditions.rgb_d[0];
  double g_f = g_c / viewing_conditions.rgb_d[1];
  double b_f = b_c / viewing_conditions.rgb_d[2];

  double x = 1.86206786 * r_f - 1.01125463 * g_f + 0.14918677 * b_f;
  double y = 0.38752654 * r_f + 0.62144744 * g_f - 0.00897398 * b_f;
  double z = -0.01584150 * r_f - 0.03412294 * g_f + 1.04996444 * b_f;

  return {x, y, z};
}

Hct InViewingConditions(Hct hct, ViewingConditions vc) {
  // 1. Use CAM16 to find XYZ coordinates of color in specified VC.
  Cam cam16 = CamFromInt(hct.ToInt());
  Vec3 viewed_in_vc = XyzInViewingConditions(cam16, vc);

  // 2. Create CAM16 of those XYZ coordinates in default VC.
  Cam recast_in_vc =
      CamFromXyzAndViewingConditions(viewed_in_vc.a, viewed_in_vc.b,
                                     viewed_in_vc.c, kDefaultViewingConditions);

  // 3. Create HCT from:
  // - CAM16 using default VC with XYZ coordinates in specified VC.
  // - L* converted from Y in XYZ coordinates in specified VC.
  Hct recast_hct =
      Hct(recast_in_vc.hue, recast_in_vc.chroma, LstarFromY(viewed_in_vc.b));
  return recast_hct;
}

ViewingConditions ViewingConditionsForAlbers(const DynamicScheme& scheme) {
  return CreateViewingConditions(
      /*white_point=*/new double[]{95.047, 100.0, 108.883},
      /*adapting_luminance=*/-1.0,
      /*background_lstar=*/scheme.is_dark ? 30.0 : 80.0,
      /*surround=*/2.0,
      /*discounting_illuminant=*/false);
}

double PerformAlbers(Hct pre_albers, const DynamicScheme& scheme) {
  Hct albersd =
      InViewingConditions(pre_albers, ViewingConditionsForAlbers(scheme));
  if (TonePrefersLightForeground(pre_albers.get_tone()) &&
      !ToneAllowsLightForeground(albersd.get_tone())) {
    return EnableLightForeground(pre_albers.get_tone());
  } else {
    return EnableLightForeground(albersd.get_tone());
  }
}

double FindDesiredChromaByTone(double hue, double chroma, double tone,
                               bool by_decreasing_tone) {
  double answer = tone;

  Hct closest_to_chroma = Hct(hue, chroma, tone);
  if (closest_to_chroma.get_chroma() < chroma) {
    double chroma_peak = closest_to_chroma.get_chroma();
    while (closest_to_chroma.get_chroma() < chroma) {
      answer += by_decreasing_tone ? -1.0 : 1.0;
      Hct potential_solution = Hct(hue, chroma, answer);
      if (chroma_peak > potential_solution.get_chroma()) {
        break;
      }
      if (abs(potential_solution.get_chroma() - chroma) < 0.4) {
        break;
      }

      double potential_delta = abs(potential_solution.get_chroma() - chroma);
      double current_delta = abs(closest_to_chroma.get_chroma() - chroma);
      if (potential_delta < current_delta) {
        closest_to_chroma = potential_solution;
      }
      chroma_peak = fmax(chroma_peak, potential_solution.get_chroma());
    }
  }

  return answer;
}

constexpr double kContentAccentToneDelta = 15.0;
DynamicColor highestSurface(const DynamicScheme& s) {
  return s.is_dark ? MaterialDynamicColors::SurfaceBright()
                   : MaterialDynamicColors::SurfaceDim();
}

DynamicColor MaterialDynamicColors::PrimaryPaletteKeyColor() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.primary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double {
        return s.primary_palette.get_key_color().get_tone();
      },
      /*toneDeltaConstraint*/ std::nullopt,
      /*background*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::SecondaryPaletteKeyColor() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.secondary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double {
        return s.secondary_palette.get_key_color().get_tone();
      },
      /*toneDeltaConstraint*/ std::nullopt,
      /*background*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::TertiaryPaletteKeyColor() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.tertiary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double {
        return s.tertiary_palette.get_key_color().get_tone();
      },
      /*toneDeltaConstraint*/ std::nullopt,
      /*background*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::NeutralPaletteKeyColor() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.neutral_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double {
        return s.neutral_palette.get_key_color().get_tone();
      },
      /*toneDeltaConstraint*/ std::nullopt,
      /*background*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::NeutralVariantPaletteKeyColor() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.neutral_variant_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double {
        return s.neutral_variant_palette.get_key_color().get_tone();
      },
      /*toneDeltaConstraint*/ std::nullopt,
      /*background*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::Background() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.neutral_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double { return s.is_dark ? 6 : 98; },
      /*toneDeltaConstraint*/ std::nullopt,
      /*background*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::OnBackground() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.neutral_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double { return s.is_dark ? 90 : 10; },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor {
        return MaterialDynamicColors::Background();
      },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::Surface() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.neutral_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double { return s.is_dark ? 6 : 98; },
      /*toneDeltaConstraint*/ std::nullopt,
      /*background*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::SurfaceDim() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.neutral_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double { return s.is_dark ? 6 : 87; },
      /*toneDeltaConstraint*/ std::nullopt,
      /*background*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::SurfaceBright() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.neutral_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double { return s.is_dark ? 24 : 98; },
      /*toneDeltaConstraint*/ std::nullopt,
      /*background*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::SurfaceContainerLowest() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.neutral_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double { return s.is_dark ? 4 : 100; },
      /*toneDeltaConstraint*/ std::nullopt,
      /*background*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::SurfaceContainerLow() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.neutral_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double { return s.is_dark ? 10 : 96; },
      /*toneDeltaConstraint*/ std::nullopt,
      /*background*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::SurfaceContainer() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.neutral_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double { return s.is_dark ? 12 : 94; },
      /*toneDeltaConstraint*/ std::nullopt,
      /*background*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::SurfaceContainerHigh() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.neutral_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double { return s.is_dark ? 17 : 92; },
      /*toneDeltaConstraint*/ std::nullopt,
      /*background*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::SurfaceContainerHighest() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.neutral_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double { return s.is_dark ? 22 : 90; },
      /*toneDeltaConstraint*/ std::nullopt,
      /*background*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::OnSurface() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.neutral_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double { return s.is_dark ? 90 : 10; },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return highestSurface(s); },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::SurfaceVariant() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.neutral_variant_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double { return s.is_dark ? 30 : 90; },
      /*toneDeltaConstraint*/ std::nullopt,
      /*background*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::OnSurfaceVariant() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.neutral_variant_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double { return s.is_dark ? 80 : 30; },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return SurfaceVariant(); },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::InverseSurface() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.neutral_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double { return s.is_dark ? 90 : 20; },
      /*toneDeltaConstraint*/ std::nullopt,
      /*background*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::InverseOnSurface() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.neutral_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double { return s.is_dark ? 20 : 95; },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return InverseSurface(); },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::Outline() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.neutral_variant_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double { return s.is_dark ? 60 : 50; },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return highestSurface(s); },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::OutlineVariant() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.neutral_variant_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double { return s.is_dark ? 30 : 80; },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return highestSurface(s); },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::Shadow() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.neutral_palette; },
      /*tone*/ [](const DynamicScheme& s) -> double { return 0; },
      /*toneDeltaConstraint*/ std::nullopt,
      /*background*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::Scrim() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.neutral_palette; },
      /*tone*/ [](const DynamicScheme& s) -> double { return 0; },
      /*toneDeltaConstraint*/ std::nullopt,
      /*background*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::SurfaceTint() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.primary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double { return s.is_dark ? 80 : 40; },
      /*toneDeltaConstraint*/ std::nullopt,
      /*background*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::Primary() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.primary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double {
        if (IsMonochrome(s)) {
          return s.is_dark ? 100 : 0;
        }
        return s.is_dark ? 80 : 40;
      },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return highestSurface(s); },
      /*toneDeltaConstraint*/
      [](const DynamicScheme& s) -> ToneDeltaConstraint {
        return ToneDeltaConstraint(
            /*delta*/ kContentAccentToneDelta,
            /*keepAway*/ PrimaryContainer(),
            /*keepAwayPolarity*/ s.is_dark ? TonePolarity::kDarker
                                           : TonePolarity::kLighter);
      });
}

DynamicColor MaterialDynamicColors::OnPrimary() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.primary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double {
        if (IsMonochrome(s)) {
          return s.is_dark ? 10 : 90;
        }
        return s.is_dark ? 20 : 100;
      },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return Primary(); },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::PrimaryContainer() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.primary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double {
        if (IsFidelity(s)) {
          return PerformAlbers(s.source_color_hct, s);
        }
        if (IsMonochrome(s)) {
          return s.is_dark ? 85 : 25;
        }
        return s.is_dark ? 30 : 90;
      },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return highestSurface(s); },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::OnPrimaryContainer() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.primary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double {
        if (IsFidelity(s)) {
          return ForegroundTone(PrimaryContainer().tone(s), 4.5);
        }
        if (IsMonochrome(s)) {
          return s.is_dark ? 0 : 100;
        }
        return s.is_dark ? 90 : 10;
      },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return PrimaryContainer(); },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::InversePrimary() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.primary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double { return s.is_dark ? 40 : 80; },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return InverseSurface(); },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::Secondary() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.secondary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double { return s.is_dark ? 80 : 40; },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return highestSurface(s); },
      /*toneDeltaConstraint*/
      [](const DynamicScheme& s) -> ToneDeltaConstraint {
        return ToneDeltaConstraint(
            /*delta*/ kContentAccentToneDelta,
            /*keepAway*/ SecondaryContainer(),
            /*keepAwayPolarity*/ s.is_dark ? TonePolarity::kDarker
                                           : TonePolarity::kLighter);
      });
}

DynamicColor MaterialDynamicColors::OnSecondary() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.secondary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double {
        if (IsMonochrome(s)) {
          return s.is_dark ? 10 : 100;
        }
        return s.is_dark ? 20 : 100;
      },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return Secondary(); },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::SecondaryContainer() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.secondary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double {
        if (IsMonochrome(s)) {
          return s.is_dark ? 30 : 85;
        }
        double initial_tone = s.is_dark ? 30.0 : 90.0;
        if (!IsFidelity(s)) {
          return initial_tone;
        }
        // TODO: open up hue and chroma
        double answer = FindDesiredChromaByTone(
            s.secondary_palette.get_hue(), s.secondary_palette.get_chroma(),
            initial_tone, s.is_dark ? false : true);
        answer = PerformAlbers(Hct(s.secondary_palette.get(answer)), s);
        return answer;
      },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return highestSurface(s); },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::OnSecondaryContainer() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.secondary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double {
        if (!IsFidelity(s)) {
          return s.is_dark ? 90 : 10;
        }
        return ForegroundTone(SecondaryContainer().tone(s), 4.5);
      },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor {
        return SecondaryContainer();
      },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::Tertiary() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.tertiary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double {
        if (IsMonochrome(s)) {
          return s.is_dark ? 90 : 25;
        }
        return s.is_dark ? 80 : 40;
      },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return highestSurface(s); },
      /*toneDeltaConstraint*/
      [](const DynamicScheme& s) -> ToneDeltaConstraint {
        return ToneDeltaConstraint(
            /*delta*/ kContentAccentToneDelta,
            /*keepAway*/ TertiaryContainer(),
            /*keepAwayPolarity*/ s.is_dark ? TonePolarity::kDarker
                                           : TonePolarity::kLighter);
      });
}

DynamicColor MaterialDynamicColors::OnTertiary() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.tertiary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double {
        if (IsMonochrome(s)) {
          return s.is_dark ? 10 : 90;
        }
        return s.is_dark ? 20 : 100;
      },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return Tertiary(); },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::TertiaryContainer() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.tertiary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double {
        if (IsMonochrome(s)) {
          return s.is_dark ? 60 : 49;
        }
        if (!IsFidelity(s)) {
          return s.is_dark ? 30 : 90;
        }

        double albersTone = PerformAlbers(
            Hct(s.tertiary_palette.get(s.source_color_hct.get_tone())), s);
        Hct proposedHct = Hct(s.tertiary_palette.get(albersTone));
        return FixIfDisliked(proposedHct).get_tone();
      },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return highestSurface(s); },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::OnTertiaryContainer() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.tertiary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double {
        if (IsMonochrome(s)) {
          return s.is_dark ? 0 : 100;
        }
        if (!IsFidelity(s)) {
          return s.is_dark ? 90 : 10;
        }
        return ForegroundTone(TertiaryContainer().tone(s), 4.5);
      },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor {
        return TertiaryContainer();
      },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::Error() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.error_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double { return s.is_dark ? 80 : 40; },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return highestSurface(s); },
      /*toneDeltaConstraint*/
      [](const DynamicScheme& s) -> ToneDeltaConstraint {
        return ToneDeltaConstraint(
            /*delta*/ kContentAccentToneDelta,
            /*keepAway*/ ErrorContainer(),
            /*keepAwayPolarity*/ s.is_dark ? TonePolarity::kDarker
                                           : TonePolarity::kLighter);
      });
}

DynamicColor MaterialDynamicColors::OnError() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.error_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double { return s.is_dark ? 20 : 100; },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return Error(); },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::ErrorContainer() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.error_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double { return s.is_dark ? 30 : 90; },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return highestSurface(s); },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::OnErrorContainer() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.error_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double { return s.is_dark ? 90 : 10; },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return ErrorContainer(); },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::PrimaryFixed() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.primary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double {
        if (IsMonochrome(s)) {
          return s.is_dark ? 100 : 10;
        }
        return 90;
      },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return highestSurface(s); },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::PrimaryFixedDim() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.primary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double {
        if (IsMonochrome(s)) {
          return s.is_dark ? 90 : 20;
        }
        return 80;
      },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return highestSurface(s); },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::OnPrimaryFixed() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.primary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double {
        if (IsMonochrome(s)) {
          return s.is_dark ? 10 : 90;
        }
        return 10;
      },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return PrimaryFixedDim(); },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::OnPrimaryFixedVariant() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.primary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double {
        if (IsMonochrome(s)) {
          return s.is_dark ? 30 : 70;
        }
        return 30;
      },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return PrimaryFixedDim(); },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::SecondaryFixed() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.secondary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double {
        return IsMonochrome(s) ? 80 : 90;
      },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return highestSurface(s); },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::SecondaryFixedDim() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.secondary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double {
        return IsMonochrome(s) ? 70 : 80;
      },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return highestSurface(s); },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::OnSecondaryFixed() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.secondary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double { return 10; },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor {
        return SecondaryFixedDim();
      },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::OnSecondaryFixedVariant() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.secondary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double {
        return IsMonochrome(s) ? 25 : 30;
      },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor {
        return SecondaryFixedDim();
      },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::TertiaryFixed() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.tertiary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double {
        return IsMonochrome(s) ? 40 : 90;
      },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return highestSurface(s); },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::TertiaryFixedDim() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.tertiary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double {
        return IsMonochrome(s) ? 30 : 80;
      },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return highestSurface(s); },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::OnTertiaryFixed() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.tertiary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double {
        return IsMonochrome(s) ? 90 : 10;
      },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return TertiaryFixedDim(); },
      /*toneDeltaConstraint*/ std::nullopt);
}

DynamicColor MaterialDynamicColors::OnTertiaryFixedVariant() {
  return DynamicColor::FromPalette(
      /*palette*/ [](const DynamicScheme& s)
                      -> TonalPalette { return s.tertiary_palette; },
      /*tone*/
      [](const DynamicScheme& s) -> double {
        return IsMonochrome(s) ? 70 : 30;
      },
      /*background*/
      [](const DynamicScheme& s) -> DynamicColor { return TertiaryFixedDim(); },
      /*toneDeltaConstraint*/ std::nullopt);
}

}  // namespace material_color_utilities
