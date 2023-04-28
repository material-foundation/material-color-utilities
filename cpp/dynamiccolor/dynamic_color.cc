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

#include "cpp/dynamiccolor/dynamic_color.h"

#include <algorithm>
#include <cmath>
#include <functional>
#include <optional>

#include "cpp/cam/hct.h"
#include "cpp/contrast/contrast.h"
#include "cpp/dynamiccolor/tone_delta_constraint.h"
#include "cpp/palettes/tones.h"
#include "cpp/scheme/dynamic_scheme.h"

namespace material_color_utilities {

using std::function;
using std::nullopt;
using std::optional;

using DoubleFunction = function<double(const DynamicScheme&)>;

template <class T, class U>
optional<U> SafeCall(optional<function<optional<U>(const T&)>> f, const T& x) {
  if (f == nullopt) {
    return nullopt;
  } else {
    return f.value()(x);
  }
}

template <class T, class U>
optional<U> SafeCallCleanResult(optional<function<U(T)>> f, T x) {
  if (f == nullopt) {
    return nullopt;
  } else {
    return f.value()(x);
  }
}

/**
 * Whether a dynamic color's background has a background.
 */
bool BackgroundHasBackground(
    optional<function<optional<DynamicColor>(const DynamicScheme&)>> background,
    const DynamicScheme& scheme) {
  optional<DynamicColor> bg = SafeCall(background, scheme);
  if (bg == nullopt) {
    return false;
  } else {
    return bg->background(scheme) != nullopt;
  }
}

double ForegroundTone(double bg_tone, double ratio) {
  double lighter_tone = LighterUnsafe(/*tone*/ bg_tone, /*ratio*/ ratio);
  double darker_tone = DarkerUnsafe(/*tone*/ bg_tone, /*ratio*/ ratio);
  double lighter_ratio = RatioOfTones(lighter_tone, bg_tone);
  double darker_ratio = RatioOfTones(darker_tone, bg_tone);
  double prefer_lighter = TonePrefersLightForeground(bg_tone);

  if (prefer_lighter) {
    double negligible_difference =
        (abs(lighter_ratio - darker_ratio) < 0.1 && lighter_ratio < ratio &&
         darker_ratio < ratio);
    return lighter_ratio >= ratio || lighter_ratio >= darker_ratio ||
                   negligible_difference
               ? lighter_tone
               : darker_tone;
  } else {
    return darker_ratio >= ratio || darker_ratio >= lighter_ratio
               ? darker_tone
               : lighter_tone;
  }
}

double EnableLightForeground(double tone) {
  if (TonePrefersLightForeground(tone) && !ToneAllowsLightForeground(tone)) {
    return 49.0;
  }
  return tone;
}

bool TonePrefersLightForeground(double tone) { return round(tone) < 60; }

bool ToneAllowsLightForeground(double tone) { return round(tone) <= 49; }

double EnsureToneDelta(
    double tone, double tone_standard, const DynamicScheme& scheme,
    optional<function<optional<ToneDeltaConstraint>(const DynamicScheme&)>>
        constraint_provider,
    function<double(DynamicColor)> tone_to_distance_from) {
  optional<ToneDeltaConstraint> constraint =
      SafeCall(constraint_provider, scheme);
  if (constraint == nullopt) {
    return tone;
  }

  double required_delta = constraint->delta;
  double keep_away_tone = tone_to_distance_from(constraint->keep_away);
  double delta = abs(tone - keep_away_tone);
  if (delta > required_delta) {
    return tone;
  }
  switch (constraint->keep_away_polarity) {
    case TonePolarity::kDarker:
      return std::clamp(keep_away_tone + required_delta, 0.0, 100.0);
    case TonePolarity::kLighter:
      return std::clamp(keep_away_tone - required_delta, 0.0, 100.0);

    case TonePolarity::kNoPreference:
      double keep_away_tone_standard = constraint->keep_away.tone(scheme);
      double prefer_lighten = tone_standard > keep_away_tone_standard;
      double alter_amount = abs(delta - required_delta);
      double lighten =
          prefer_lighten ? (tone + alter_amount <= 100.0) : tone < alter_amount;
      return lighten ? tone + alter_amount : tone - alter_amount;
  }
}

double CalculateDynamicTone(
    const DynamicScheme& scheme, DoubleFunction tone_standard,
    function<double(DynamicColor)> tone_to_judge,
    function<double(double standard_ratio, double bg_tone)> desired_tone,
    optional<function<optional<DynamicColor>(const DynamicScheme&)>> background,
    optional<function<ToneDeltaConstraint(const DynamicScheme&)>> constraint,
    optional<function<double(double standard_ratio)>> min_ratio,
    optional<function<double(double standard_ratio)>> max_ratio) {
  double tone_std = tone_standard(scheme);
  double tone_result = tone_std;
  optional<DynamicColor> bg_dynamic = SafeCall(background, scheme);
  if (bg_dynamic == nullopt) {
    return tone_result;
  }
  double bg_tone_std = bg_dynamic->tone(scheme);
  double std_ratio = RatioOfTones(tone_std, bg_tone_std);

  double bg_tone = tone_to_judge(bg_dynamic.value());
  double my_desired_tone = desired_tone(std_ratio, bg_tone);
  double current_ratio = RatioOfTones(bg_tone, my_desired_tone);
  double minimal_ratio =
      SafeCallCleanResult(min_ratio, std_ratio).value_or(1.0);
  double maximal_ratio =
      SafeCallCleanResult(max_ratio, std_ratio).value_or(21.0);

  double desired_ratio =
      std::clamp(current_ratio, minimal_ratio, maximal_ratio);
  if (desired_ratio == current_ratio) {
    tone_result = my_desired_tone;
  } else {
    tone_result = ForegroundTone(bg_tone, desired_ratio);
  }

  if (bg_dynamic->background(scheme) == nullopt) {
    tone_result = EnableLightForeground(tone_result);
  }

  return EnsureToneDelta(
      /*tone*/ tone_result,
      /*tone_standard*/ tone_std,
      /*scheme*/ scheme,
      /*constraint_provider*/ constraint,
      /*tone_to_distance_from*/ tone_to_judge);
}

double ToneMinContrastDefault(
    DoubleFunction tone,
    optional<function<optional<DynamicColor>(const DynamicScheme&)>> background,
    const DynamicScheme& scheme,
    optional<function<ToneDeltaConstraint(const DynamicScheme&)>>
        tone_delta_constraint) {
  auto desired_tone_function = [tone, background, scheme](
                                   double std_ratio, double bg_tone) -> double {
    double tone_result = tone(scheme);
    if (std_ratio >= 7.0) {
      tone_result = ForegroundTone(bg_tone, 4.5);
    } else if (std_ratio >= 3.0) {
      tone_result = ForegroundTone(bg_tone, 3.0);
    } else {
      bool bg_has_bg = BackgroundHasBackground(background, scheme);
      if (bg_has_bg) {
        tone_result = ForegroundTone(bg_tone, std_ratio);
      }
    }
    return tone_result;
  };

  return CalculateDynamicTone(
      /*scheme*/ scheme,
      /*tone_standard*/ tone,
      /*tone_to_judge*/
      [scheme](DynamicColor c) -> double {
        return c.tone_min_contrast(scheme);
      },
      /*desired_tone*/ desired_tone_function,
      /*background*/ background,
      /*constraint*/ tone_delta_constraint,
      /*min_ratio*/ nullopt,
      /*max_ratio*/
      [](double standard_ratio) -> double { return standard_ratio; });
}

double ToneMaxContrastDefault(
    DoubleFunction tone,
    optional<function<optional<DynamicColor>(const DynamicScheme&)>> background,
    const DynamicScheme& scheme,
    optional<function<ToneDeltaConstraint(const DynamicScheme&)>>
        tone_delta_constraint) {
  auto desired_tone_function = [tone, background, scheme](
                                   double std_ratio, double bg_tone) -> double {
    bool bg_has_bg = BackgroundHasBackground(background, scheme);
    if (bg_has_bg) {
      return ForegroundTone(bg_tone, 7.0);
    } else {
      return ForegroundTone(bg_tone, fmax(7.0, std_ratio));
    }
  };

  return CalculateDynamicTone(
      /*scheme*/ scheme,
      /*tone_standard*/ tone,
      /*tone_to_judge*/
      [scheme](DynamicColor c) -> double {
        return c.tone_max_contrast(scheme);
      },
      /*desired_tone*/ desired_tone_function,
      /*background*/ background,
      /*constraint*/ tone_delta_constraint,
      /*min_ratio*/ nullopt,
      /*max_ratio*/ nullopt);
}

/**
 * Default constructor.
 */
DynamicColor::DynamicColor(
    DoubleFunction hue, DoubleFunction chroma, DoubleFunction tone,
    function<optional<DynamicColor>(const DynamicScheme&)> background,
    DoubleFunction tone_min_contrast, DoubleFunction tone_max_contrast,
    optional<function<ToneDeltaConstraint(const DynamicScheme&)>>
        tone_delta_constraint)
    : hue(hue),
      chroma(chroma),
      tone(tone),
      background(background),
      tone_min_contrast(tone_min_contrast),
      tone_max_contrast(tone_max_contrast),
      tone_delta_constraint(tone_delta_constraint) {}

DynamicColor DynamicColor::FromPalette(
    function<TonalPalette(const DynamicScheme&)> palette, DoubleFunction tone,
    optional<function<optional<DynamicColor>(const DynamicScheme&)>> background,
    optional<function<ToneDeltaConstraint(const DynamicScheme&)>>
        tone_delta_constraint) {
  return DynamicColor(
      /*hue*/ [palette](const DynamicScheme& scheme)
                  -> double { return palette(scheme).get_hue(); },
      /*chroma*/
      [palette](const DynamicScheme& scheme) -> double {
        return palette(scheme).get_chroma();
      },
      /*tone*/ tone,
      /*background*/
      [background](const DynamicScheme& scheme) -> optional<DynamicColor> {
        return SafeCall(background, scheme);
      },
      /*tone_min_contrast*/
      [tone, background,
       tone_delta_constraint](const DynamicScheme& scheme) -> double {
        return ToneMinContrastDefault(tone, background, scheme,
                                      tone_delta_constraint);
      },
      /*tone_max_contrast*/
      [tone, background,
       tone_delta_constraint](const DynamicScheme& scheme) -> double {
        return ToneMaxContrastDefault(tone, background, scheme,
                                      tone_delta_constraint);
      },
      /*tone_delta_constraint*/ tone_delta_constraint);
}

Argb DynamicColor::GetArgb(const DynamicScheme& scheme) {
  return GetHct(scheme).ToInt();
}

Hct DynamicColor::GetHct(const DynamicScheme& scheme) {
  return Hct(hue(scheme), chroma(scheme), GetTone(scheme));
}

double DynamicColor::GetTone(const DynamicScheme& scheme) {
  double tone_result = tone(scheme);
  double decreasing_contrast = scheme.contrast_level < 0.0;
  if (scheme.contrast_level != 0.0) {
    double start_tone = tone(scheme);
    double end_tone = decreasing_contrast ? tone_min_contrast(scheme)
                                          : tone_max_contrast(scheme);
    double delta = (end_tone - start_tone) * abs(scheme.contrast_level);
    tone_result = delta + start_tone;
  }

  optional<DynamicColor> bg = background(scheme);
  // double? standard_ratio;
  double min_ratio = 1.0;
  double max_ratio = 21.0;
  if (bg != nullopt) {
    double bg_has_bg = bg->background(scheme) == nullopt;
    double standard_ratio = RatioOfTones(tone(scheme), bg->tone(scheme));
    if (decreasing_contrast) {
      double min_contrast_ratio = RatioOfTones(tone_min_contrast(scheme),
                                               bg->tone_min_contrast(scheme));
      if (!bg_has_bg) {
        min_ratio = min_contrast_ratio;
      }
      max_ratio = standard_ratio;
    } else {
      double max_contrast_ratio = RatioOfTones(tone_max_contrast(scheme),
                                               bg->tone_max_contrast(scheme));
      if (bg->background(scheme) != nullopt) {
        min_ratio = fmin(max_contrast_ratio, standard_ratio);
        max_ratio = fmax(max_contrast_ratio, standard_ratio);
      }
    }
  }

  tone_result = CalculateDynamicTone(
      /*scheme*/ scheme,
      /*tone_standard*/ tone,
      /*tone_to_judge*/
      [scheme](DynamicColor c) -> double { return c.GetTone(scheme); },
      /*desired_tone*/
      [tone_result](double standard_ratio, double bg_tone) -> double {
        return tone_result;
      },
      /*background*/
      [bg](const DynamicScheme& scheme) -> optional<DynamicColor> {
        return bg;
      },
      /*constraint*/ tone_delta_constraint,
      /*min_ratio*/
      [min_ratio](double standard_ratio) -> double { return min_ratio; },
      /*max_ratio*/
      [max_ratio](double standard_ratio) -> double { return max_ratio; });

  return tone_result;
}

}  // namespace material_color_utilities
