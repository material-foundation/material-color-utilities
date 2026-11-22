/*
 * Copyright 2025 Google LLC
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

package dynamiccolor;

import static dynamiccolor.DynamicScheme.Platform.PHONE;
import static dynamiccolor.DynamicScheme.Platform.WATCH;
import static dynamiccolor.ToneDeltaPair.DeltaConstraint.EXACT;
import static dynamiccolor.ToneDeltaPair.DeltaConstraint.FARTHER;
import static dynamiccolor.TonePolarity.DARKER;
import static dynamiccolor.TonePolarity.RELATIVE_LIGHTER;
import static dynamiccolor.Variant.EXPRESSIVE;
import static dynamiccolor.Variant.NEUTRAL;
import static dynamiccolor.Variant.TONAL_SPOT;
import static dynamiccolor.Variant.VIBRANT;
import static java.lang.Math.max;
import static java.lang.Math.min;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import contrast.Contrast;
import dynamiccolor.DynamicScheme.Platform;
import dynamiccolor.ToneDeltaPair.DeltaConstraint;
import hct.Hct;
import palettes.TonalPalette;
import utils.MathUtils;
import java.util.ArrayList;
import java.util.Optional;

/** {@link ColorSpec} implementation for the 2025 spec. */
class ColorSpec2025 extends ColorSpec2021 {

  ////////////////////////////////////////////////////////////////
  // Surfaces [S]                                               //
  ////////////////////////////////////////////////////////////////

  @NonNull
  @Override
  public DynamicColor background() {
    // Remapped to surface for 2025 spec.
    DynamicColor color2025 = surface().toBuilder().setName("background").build();
    return super.background().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onBackground() {
    // Remapped to onSurface for 2025 spec.
    DynamicColor.Builder color2025Builder = onSurface().toBuilder().setName("on_background");
    color2025Builder.setTone(
        (s) -> {
          return s.platform == WATCH ? 100.0 : onSurface().getTone(s);
        });
    return super.onBackground().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025Builder.build())
        .build();
  }

  @NonNull
  @Override
  public DynamicColor surface() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("surface")
            .setPalette((s) -> s.neutralPalette)
            .setTone(
                (s) -> {
                  if (s.platform == PHONE) {
                    if (s.isDark) {
                      return 4.0;
                    } else {
                      if (Hct.isYellow(s.neutralPalette.getHue())) {
                        return 99.0;
                      } else if (s.variant == VIBRANT) {
                        return 97.0;
                      } else {
                        return 98.0;
                      }
                    }
                  } else {
                    return 0.0;
                  }
                })
            .setIsBackground(true)
            .build();
    return super.surface().toBuilder().extendSpecVersion(SpecVersion.SPEC_2025, color2025).build();
  }

  @NonNull
  @Override
  public DynamicColor surfaceDim() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("surface_dim")
            .setPalette((s) -> s.neutralPalette)
            .setTone(
                (s) -> {
                  if (s.isDark || s.platform == WATCH) {
                    return 4.0;
                  } else {
                    if (Hct.isYellow(s.neutralPalette.getHue())) {
                      return 90.0;
                    } else if (s.variant == VIBRANT) {
                      return 85.0;
                    } else {
                      return 87.0;
                    }
                  }
                })
            .setIsBackground(true)
            .setChromaMultiplier(
                (s) -> {
                  if (!s.isDark && s.platform == PHONE) {
                    if (s.variant == NEUTRAL) {
                      return 2.5;
                    } else if (s.variant == TONAL_SPOT) {
                      return 1.7;
                    } else if (s.variant == EXPRESSIVE) {
                      return Hct.isYellow(s.neutralPalette.getHue()) ? 2.7 : 1.75;
                    } else if (s.variant == VIBRANT) {
                      return 1.36;
                    }
                  }
                  return 1.0;
                })
            .build();
    return super.surfaceDim().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor surfaceBright() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("surface_bright")
            .setPalette((s) -> s.neutralPalette)
            .setTone(
                (s) -> {
                  if (s.isDark || s.platform == WATCH) {
                    return 18.0;
                  } else {
                    if (Hct.isYellow(s.neutralPalette.getHue())) {
                      return 99.0;
                    } else if (s.variant == VIBRANT) {
                      return 97.0;
                    } else {
                      return 98.0;
                    }
                  }
                })
            .setIsBackground(true)
            .setChromaMultiplier(
                (s) -> {
                  if (s.isDark || s.platform == WATCH) {
                    if (s.variant == NEUTRAL) {
                      return 2.5;
                    } else if (s.variant == TONAL_SPOT) {
                      return 1.7;
                    } else if (s.variant == EXPRESSIVE) {
                      return Hct.isYellow(s.neutralPalette.getHue()) ? 2.7 : 1.75;
                    } else if (s.variant == VIBRANT) {
                      return 1.36;
                    }
                  }
                  return 1.0;
                })
            .build();
    return super.surfaceBright().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor surfaceContainerLowest() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("surface_container_lowest")
            .setPalette((s) -> s.neutralPalette)
            .setTone((s) -> (s.isDark || s.platform == WATCH) ? 0.0 : 100.0)
            .setIsBackground(true)
            .build();
    return super.surfaceContainerLowest().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor surfaceContainerLow() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("surface_container_low")
            .setPalette((s) -> s.neutralPalette)
            .setTone(
                (s) -> {
                  if (s.platform == PHONE) {
                    if (s.isDark) {
                      return 6.0;
                    } else {
                      if (Hct.isYellow(s.neutralPalette.getHue())) {
                        return 98.0;
                      } else if (s.variant == VIBRANT) {
                        return 95.0;
                      } else {
                        return 96.0;
                      }
                    }
                  } else {
                    return 15.0;
                  }
                })
            .setIsBackground(true)
            .setChromaMultiplier(
                (s) -> {
                  if (s.platform == PHONE) {
                    if (s.variant == NEUTRAL) {
                      return 1.3;
                    } else if (s.variant == TONAL_SPOT) {
                      return 1.25;
                    } else if (s.variant == EXPRESSIVE) {
                      return Hct.isYellow(s.neutralPalette.getHue()) ? 1.3 : 1.15;
                    } else if (s.variant == VIBRANT) {
                      return 1.08;
                    }
                  }
                  return 1.0;
                })
            .build();
    return super.surfaceContainerLow().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor surfaceContainer() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("surface_container")
            .setPalette((s) -> s.neutralPalette)
            .setTone(
                (s) -> {
                  if (s.platform == PHONE) {
                    if (s.isDark) {
                      return 9.0;
                    } else {
                      if (Hct.isYellow(s.neutralPalette.getHue())) {
                        return 96.0;
                      } else if (s.variant == VIBRANT) {
                        return 92.0;
                      } else {
                        return 94.0;
                      }
                    }
                  } else {
                    return 20.0;
                  }
                })
            .setIsBackground(true)
            .setChromaMultiplier(
                (s) -> {
                  if (s.platform == PHONE) {
                    if (s.variant == NEUTRAL) {
                      return 1.6;
                    } else if (s.variant == TONAL_SPOT) {
                      return 1.4;
                    } else if (s.variant == EXPRESSIVE) {
                      return Hct.isYellow(s.neutralPalette.getHue()) ? 1.6 : 1.3;
                    } else if (s.variant == VIBRANT) {
                      return 1.15;
                    }
                  }
                  return 1.0;
                })
            .build();
    return super.surfaceContainer().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor surfaceContainerHigh() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("surface_container_high")
            .setPalette((s) -> s.neutralPalette)
            .setTone(
                (s) -> {
                  if (s.platform == PHONE) {
                    if (s.isDark) {
                      return 12.0;
                    } else {
                      if (Hct.isYellow(s.neutralPalette.getHue())) {
                        return 94.0;
                      } else if (s.variant == VIBRANT) {
                        return 90.0;
                      } else {
                        return 92.0;
                      }
                    }
                  } else {
                    return 25.0;
                  }
                })
            .setIsBackground(true)
            .setChromaMultiplier(
                (s) -> {
                  if (s.platform == PHONE) {
                    if (s.variant == NEUTRAL) {
                      return 1.9;
                    } else if (s.variant == TONAL_SPOT) {
                      return 1.5;
                    } else if (s.variant == EXPRESSIVE) {
                      return Hct.isYellow(s.neutralPalette.getHue()) ? 1.95 : 1.45;
                    } else if (s.variant == VIBRANT) {
                      return 1.22;
                    }
                  }
                  return 1.0;
                })
            .build();
    return super.surfaceContainerHigh().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor surfaceContainerHighest() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("surface_container_highest")
            .setPalette((s) -> s.neutralPalette)
            .setTone(
                (s) -> {
                  if (s.isDark || s.platform == WATCH) {
                    return 15.0;
                  } else {
                    if (Hct.isYellow(s.neutralPalette.getHue())) {
                      return 92.0;
                    } else if (s.variant == VIBRANT) {
                      return 88.0;
                    } else {
                      return 90.0;
                    }
                  }
                })
            .setIsBackground(true)
            .setChromaMultiplier(
                (s) -> {
                  if (s.variant == NEUTRAL) {
                    return 2.2;
                  } else if (s.variant == TONAL_SPOT) {
                    return 1.7;
                  } else if (s.variant == EXPRESSIVE) {
                    return Hct.isYellow(s.neutralPalette.getHue()) ? 2.3 : 1.6;
                  } else if (s.variant == VIBRANT) {
                    return 1.29;
                  }
                  return 1.0;
                })
            .build();
    return super.surfaceContainerHighest().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onSurface() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("on_surface")
            .setPalette((s) -> s.neutralPalette)
            .setTone(
                (s) -> {
                  if (s.platform == PHONE && s.variant == Variant.VIBRANT) {
                    return tMaxC(s.neutralPalette, 0, 100, 1.1);
                  } else {
                    return DynamicColor.getInitialToneFromBackground(
                            (scheme) -> {
                              if (scheme.platform == PHONE) {
                                return scheme.isDark ? surfaceBright() : surfaceDim();
                              } else {
                                return surfaceContainerHigh();
                              }
                            })
                        .apply(s);
                  }
                })
            .setChromaMultiplier(
                (s) -> {
                  if (s.platform == PHONE) {
                    if (s.variant == NEUTRAL) {
                      return 2.2;
                    } else if (s.variant == TONAL_SPOT) {
                      return 1.7;
                    } else if (s.variant == EXPRESSIVE) {
                      return Hct.isYellow(s.neutralPalette.getHue()) ? (s.isDark ? 3.0 : 2.3) : 1.6;
                    }
                  }
                  return 1.0;
                })
            .setBackground(
                (s) -> {
                  if (s.platform == PHONE) {
                    return s.isDark ? surfaceBright() : surfaceDim();
                  } else {
                    return surfaceContainerHigh();
                  }
                })
            .setContrastCurve(
                (s) ->
                    s.platform == PHONE
                        ? (s.isDark ? getContrastCurve(11) : getContrastCurve(9))
                        : new ContrastCurve(4.5, 9.0, 11.0, 21.0))
            .build();
    return super.onSurface().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor surfaceVariant() {
    // Remapped to surfaceContainerHighest for 2025 spec.
    DynamicColor color2025 =
        surfaceContainerHighest().toBuilder().setName("surface_variant").build();
    return super.surfaceVariant().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onSurfaceVariant() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("on_surface_variant")
            .setPalette((s) -> s.platform == WATCH ? s.neutralVariantPalette : s.neutralPalette)
            .setChromaMultiplier(
                (s) -> {
                  if (s.platform == PHONE) {
                    if (s.variant == NEUTRAL) {
                      return 2.2;
                    } else if (s.variant == TONAL_SPOT) {
                      return 1.7;
                    } else if (s.variant == EXPRESSIVE) {
                      return Hct.isYellow(s.neutralPalette.getHue()) ? (s.isDark ? 3.0 : 2.3) : 1.6;
                    }
                  }
                  return 1.0;
                })
            .setBackground(
                (s) -> {
                  if (s.platform == PHONE) {
                    return s.isDark ? surfaceBright() : surfaceDim();
                  } else {
                    return surfaceContainerHigh();
                  }
                })
            .setContrastCurve(
                (s) ->
                    s.platform == PHONE
                        ? (s.isDark ? getContrastCurve(6) : getContrastCurve(4.5))
                        : new ContrastCurve(3.0, 7.0, 7.0, 11.0))
            .build();
    return super.onSurfaceVariant().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor inverseSurface() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("inverse_surface")
            .setPalette((s) -> s.neutralPalette)
            .setTone((s) -> (s.isDark || s.platform == WATCH) ? 98.0 : 4.0)
            .setIsBackground(true)
            .build();
    return super.inverseSurface().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor inverseOnSurface() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("inverse_on_surface")
            .setPalette((s) -> s.neutralPalette)
            .setBackground((s) -> inverseSurface())
            .setContrastCurve((s) -> getContrastCurve(7))
            .build();
    return super.inverseOnSurface().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor outline() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("outline")
            .setPalette((s) -> s.platform == WATCH ? s.neutralVariantPalette : s.neutralPalette)
            .setChromaMultiplier(
                (s) -> {
                  if (s.platform == PHONE) {
                    if (s.variant == NEUTRAL) {
                      return 2.2;
                    } else if (s.variant == TONAL_SPOT) {
                      return 1.7;
                    } else if (s.variant == EXPRESSIVE) {
                      return Hct.isYellow(s.neutralPalette.getHue()) ? (s.isDark ? 3.0 : 2.3) : 1.6;
                    }
                  }
                  return 1.0;
                })
            .setBackground(
                (s) -> {
                  if (s.platform == PHONE) {
                    return s.isDark ? surfaceBright() : surfaceDim();
                  } else {
                    return surfaceContainerHigh();
                  }
                })
            .setContrastCurve(
                (s) ->
                    s.platform == PHONE
                        ? getContrastCurve(3)
                        : new ContrastCurve(1.5, 4.5, 4.5, 7.0))
            .build();
    return super.outline().toBuilder().extendSpecVersion(SpecVersion.SPEC_2025, color2025).build();
  }

  @NonNull
  @Override
  public DynamicColor outlineVariant() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("outline_variant")
            .setPalette((s) -> s.platform == WATCH ? s.neutralVariantPalette : s.neutralPalette)
            .setChromaMultiplier(
                (s) -> {
                  if (s.platform == PHONE) {
                    if (s.variant == NEUTRAL) {
                      return 2.2;
                    } else if (s.variant == TONAL_SPOT) {
                      return 1.7;
                    } else if (s.variant == EXPRESSIVE) {
                      return Hct.isYellow(s.neutralPalette.getHue()) ? (s.isDark ? 3.0 : 2.3) : 1.6;
                    }
                  }
                  return 1.0;
                })
            .setBackground(
                (s) -> {
                  if (s.platform == PHONE) {
                    return s.isDark ? surfaceBright() : surfaceDim();
                  } else {
                    return surfaceContainerHigh();
                  }
                })
            .setContrastCurve(
                (s) ->
                    s.platform == PHONE
                        ? getContrastCurve(1.5)
                        : new ContrastCurve(1.0, 3.0, 3.0, 4.5))
            .build();
    return super.outlineVariant().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor surfaceTint() {
    // Remapped to primary for 2025 spec.
    DynamicColor color2025 = primary().toBuilder().setName("surface_tint").build();
    return super.surfaceTint().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  ////////////////////////////////////////////////////////////////
  // Primaries [P]                                              //
  ////////////////////////////////////////////////////////////////

  @NonNull
  @Override
  public DynamicColor primary() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("primary")
            .setPalette((s) -> s.primaryPalette)
            .setTone(
                (s) -> {
                  if (s.platform == WATCH) {
                    return s.variant == NEUTRAL
                        ? 90.0
                        : mainTone(s.primaryPalette, s.variant == TONAL_SPOT ? 90.0 : 100.0);
                  } else if (s.variant == NEUTRAL) {
                    return s.isDark ? 80.0 : 40.0;
                  } else if (s.variant == TONAL_SPOT) {
                    return s.isDark ? 80.0 : tMaxC(s.primaryPalette);
                  } else if (s.variant == EXPRESSIVE) {
                    return tMaxC(
                        s.primaryPalette,
                        0,
                        s.isDark
                            ? (Hct.isCyan(s.primaryPalette.getHue()) ? 88 : 98)
                            : (Hct.isYellow(s.primaryPalette.getHue()) ? 25 : 98));
                  } else { // VIBRANT
                    return tMaxC(
                        s.primaryPalette, 0, Hct.isCyan(s.primaryPalette.getHue()) ? 88 : 98);
                  }
                })
            .setIsBackground(true)
            .setBackground(
                (s) -> {
                  if (s.platform == PHONE) {
                    return s.isDark ? surfaceBright() : surfaceDim();
                  } else {
                    return surfaceContainerHigh();
                  }
                })
            .setContrastCurve(
                (s) -> s.platform == PHONE ? getContrastCurve(4.5) : getContrastCurve(7))
            .setToneDeltaPair(
                (s) ->
                    s.platform == PHONE
                        ? new ToneDeltaPair(
                            primaryContainer(), primary(), 5.0, RELATIVE_LIGHTER, FARTHER)
                        : null)
            .build();
    return super.primary().toBuilder().extendSpecVersion(SpecVersion.SPEC_2025, color2025).build();
  }

  @NonNull
  @Override
  public DynamicColor primaryDim() {
    return new DynamicColor.Builder()
        .setName("primary_dim")
        .setPalette((s) -> s.primaryPalette)
        .setTone(
            (s) -> {
              if (s.platform == WATCH) {
                return s.variant == NEUTRAL
                    ? 85.0
                    : dimTone(s.primaryPalette, s.variant == TONAL_SPOT ? 90.0 : 100.0);
              } else if (s.variant == NEUTRAL) {
                return 85.0;
              } else if (s.variant == TONAL_SPOT) {
                return tMaxC(s.primaryPalette, 0, 90);
              } else {
                return tMaxC(s.primaryPalette);
              }
            })
        .setIsBackground(true)
        .setBackground((s) -> surfaceContainerHigh())
        .setContrastCurve(
            (s) ->
                s.platform == WATCH ? new ContrastCurve(4.5, 4.5, 4.5, 4.5) : getContrastCurve(4.5))
        .setToneDeltaPair(
            (s) ->
                s.platform == WATCH
                    ? null
                    : new ToneDeltaPair(primaryDim(), primary(), 5.0, DARKER, FARTHER))
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onPrimary() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("on_primary")
            .setPalette((s) -> s.primaryPalette)
            .setBackground((s) -> s.platform == PHONE ? primary() : primaryDim())
            .setContrastCurve(
                (s) -> s.platform == PHONE ? getContrastCurve(6) : getContrastCurve(7))
            .build();
    return super.onPrimary().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor primaryContainer() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("primary_container")
            .setPalette((s) -> s.primaryPalette)
            .setTone(
                (s) -> {
                  if (s.platform == WATCH) {
                    return 30.0;
                  } else if (s.variant == NEUTRAL) {
                    return s.isDark ? 30.0 : 90.0;
                  } else if (s.variant == TONAL_SPOT) {
                    return s.isDark
                        ? tMinC(s.primaryPalette, 35, 93)
                        : tMaxC(s.primaryPalette, 0, 90);
                  } else if (s.variant == EXPRESSIVE) {
                    return s.isDark
                        ? tMinC(s.primaryPalette, 30, 93)
                        : tMaxC(
                            s.primaryPalette, 78, Hct.isCyan(s.primaryPalette.getHue()) ? 88 : 90);
                  } else { // VIBRANT
                    return s.isDark
                        ? tMinC(s.primaryPalette, 66, 93)
                        : tMaxC(
                            s.primaryPalette, 66, Hct.isCyan(s.primaryPalette.getHue()) ? 88 : 93);
                  }
                })
            .setIsBackground(true)
            .setBackground(
                (s) -> {
                  if (s.platform == PHONE) {
                    return s.isDark ? surfaceBright() : surfaceDim();
                  } else {
                    return surfaceContainerHigh();
                  }
                })
            .setToneDeltaPair(
                (s) ->
                    s.platform == WATCH
                        ? new ToneDeltaPair(primaryContainer(), primaryDim(), 10.0, DARKER, FARTHER)
                        : null)
            .setContrastCurve(
                (s) ->
                    s.platform == PHONE
                        ? (s.contrastLevel > 0 ? getContrastCurve(1.5) : null)
                        : new ContrastCurve(1.0, 1.0, 3.0, 4.5))
            .build();
    return super.primaryContainer().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onPrimaryContainer() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("on_primary_container")
            .setPalette((s) -> s.primaryPalette)
            .setBackground((s) -> primaryContainer())
            .setContrastCurve(
                (s) ->
                    s.platform == PHONE
                        ? getContrastCurve(6)
                        : new ContrastCurve(3.0, 7.0, 7.0, 11.0))
            .build();
    return super.onPrimaryContainer().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor inversePrimary() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("inverse_primary")
            .setPalette((s) -> s.primaryPalette)
            .setTone((s) -> tMaxC(s.primaryPalette))
            .setBackground((s) -> inverseSurface())
            .setContrastCurve(
                (s) -> s.platform == PHONE ? getContrastCurve(6) : getContrastCurve(7))
            .build();
    return super.inversePrimary().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  ////////////////////////////////////////////////////////////////
  // Secondaries [Q]                                            //
  ////////////////////////////////////////////////////////////////

  @NonNull
  @Override
  public DynamicColor secondary() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("secondary")
            .setPalette((s) -> s.secondaryPalette)
            .setTone(
                (s) -> {
                  if (s.platform == WATCH) {
                    return s.variant == NEUTRAL ? 90.0 : mainTone(s.secondaryPalette, 90.0);
                  } else if (s.variant == NEUTRAL) {
                    return s.isDark ? tMinC(s.secondaryPalette, 0, 98) : tMaxC(s.secondaryPalette);
                  } else if (s.variant == VIBRANT) {
                    return tMaxC(s.secondaryPalette, 0, s.isDark ? 90 : 98);
                  } else { // EXPRESSIVE and TONAL_SPOT
                    return s.isDark ? 80.0 : tMaxC(s.secondaryPalette);
                  }
                })
            .setIsBackground(true)
            .setBackground(
                (s) -> {
                  if (s.platform == PHONE) {
                    return s.isDark ? surfaceBright() : surfaceDim();
                  } else {
                    return surfaceContainerHigh();
                  }
                })
            .setContrastCurve(
                (s) -> s.platform == PHONE ? getContrastCurve(4.5) : getContrastCurve(7))
            .setToneDeltaPair(
                (s) ->
                    s.platform == PHONE
                        ? new ToneDeltaPair(
                            secondaryContainer(), secondary(), 5.0, RELATIVE_LIGHTER, FARTHER)
                        : null)
            .build();
    return super.secondary().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @Nullable
  @Override
  public DynamicColor secondaryDim() {
    return new DynamicColor.Builder()
        .setName("secondary_dim")
        .setPalette((s) -> s.secondaryPalette)
        .setTone(
            (s) -> {
              if (s.platform == WATCH) {
                return s.variant == NEUTRAL ? 85.0 : dimTone(s.secondaryPalette, 90.0);
              } else if (s.variant == NEUTRAL) {
                return 85.0;
              } else {
                return tMaxC(s.secondaryPalette, 0, 90);
              }
            })
        .setIsBackground(true)
        .setBackground((s) -> surfaceContainerHigh())
        .setContrastCurve(
            (s) ->
                s.platform == WATCH ? new ContrastCurve(4.5, 4.5, 4.5, 4.5) : getContrastCurve(4.5))
        .setToneDeltaPair(
            (s) ->
                s.platform == WATCH
                    ? null
                    : new ToneDeltaPair(secondaryDim(), secondary(), 5.0, DARKER, FARTHER))
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onSecondary() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("on_secondary")
            .setPalette((s) -> s.secondaryPalette)
            .setBackground((s) -> s.platform == PHONE ? secondary() : secondaryDim())
            .setContrastCurve(
                (s) -> s.platform == PHONE ? getContrastCurve(6) : getContrastCurve(7))
            .build();
    return super.onSecondary().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor secondaryContainer() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("secondary_container")
            .setPalette((s) -> s.secondaryPalette)
            .setTone(
                (s) -> {
                  if (s.platform == WATCH) {
                    return 30.0;
                  } else if (s.variant == VIBRANT) {
                    return s.isDark
                        ? tMinC(s.secondaryPalette, 30, 40)
                        : tMaxC(s.secondaryPalette, 84, 90);
                  } else if (s.variant == EXPRESSIVE) {
                    return s.isDark ? 15.0 : tMaxC(s.secondaryPalette, 90, 95);
                  } else {
                    return s.isDark ? 25.0 : 90.0;
                  }
                })
            .setIsBackground(true)
            .setBackground(
                (s) -> {
                  if (s.platform == PHONE) {
                    return s.isDark ? surfaceBright() : surfaceDim();
                  } else {
                    return surfaceContainerHigh();
                  }
                })
            .setToneDeltaPair(
                (s) ->
                    s.platform == WATCH
                        ? new ToneDeltaPair(
                            secondaryContainer(), secondaryDim(), 10.0, DARKER, FARTHER)
                        : null)
            .setContrastCurve(
                (s) ->
                    s.platform == PHONE
                        ? (s.contrastLevel > 0 ? getContrastCurve(1.5) : null)
                        : new ContrastCurve(1.0, 1.0, 3.0, 4.5))
            .build();
    return super.secondaryContainer().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onSecondaryContainer() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("on_secondary_container")
            .setPalette((s) -> s.secondaryPalette)
            .setBackground((s) -> secondaryContainer())
            .setContrastCurve(
                (s) ->
                    s.platform == PHONE
                        ? getContrastCurve(6)
                        : new ContrastCurve(3.0, 7.0, 7.0, 11.0))
            .build();
    return super.onSecondaryContainer().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  ////////////////////////////////////////////////////////////////
  // Tertiaries [T]                                             //
  ////////////////////////////////////////////////////////////////

  @NonNull
  @Override
  public DynamicColor tertiary() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("tertiary")
            .setPalette((s) -> s.tertiaryPalette)
            .setTone(
                (s) -> {
                  if (s.platform == WATCH) {
                    return mainTone(s.tertiaryPalette, s.variant == TONAL_SPOT ? 90.0 : 100.0);
                  } else if (s.variant == EXPRESSIVE || s.variant == VIBRANT) {
                    return tMaxC(
                        s.tertiaryPalette,
                        /* lowerBound= */ 0,
                        /* upperBound= */ Hct.isCyan(s.tertiaryPalette.getHue())
                            ? 88
                            : (s.isDark ? 98 : 100));
                  } else { // NEUTRAL and TONAL_SPOT
                    return s.isDark ? tMaxC(s.tertiaryPalette, 0, 98) : tMaxC(s.tertiaryPalette);
                  }
                })
            .setIsBackground(true)
            .setBackground(
                (s) -> {
                  if (s.platform == PHONE) {
                    return s.isDark ? surfaceBright() : surfaceDim();
                  } else {
                    return surfaceContainerHigh();
                  }
                })
            .setContrastCurve(
                (s) -> s.platform == PHONE ? getContrastCurve(4.5) : getContrastCurve(7))
            .setToneDeltaPair(
                (s) ->
                    s.platform == PHONE
                        ? new ToneDeltaPair(
                            tertiaryContainer(), tertiary(), 5.0, RELATIVE_LIGHTER, FARTHER)
                        : null)
            .build();
    return super.tertiary().toBuilder().extendSpecVersion(SpecVersion.SPEC_2025, color2025).build();
  }

  @Nullable
  @Override
  public DynamicColor tertiaryDim() {
    return new DynamicColor.Builder()
        .setName("tertiary_dim")
        .setPalette((s) -> s.tertiaryPalette)
        .setTone(
            (s) -> {
              if (s.platform == WATCH) {
                return dimTone(s.tertiaryPalette, s.variant == TONAL_SPOT ? 90.0 : 100.0);
              } else if (s.variant == TONAL_SPOT) {
                return tMaxC(s.tertiaryPalette, 0, 90);
              } else {
                return tMaxC(s.tertiaryPalette);
              }
            })
        .setIsBackground(true)
        .setBackground((s) -> surfaceContainerHigh())
        .setContrastCurve(
            (s) ->
                s.platform == WATCH ? new ContrastCurve(4.5, 4.5, 4.5, 4.5) : getContrastCurve(4.5))
        .setToneDeltaPair(
            (s) ->
                s.platform == WATCH
                    ? null
                    : new ToneDeltaPair(tertiaryDim(), tertiary(), 5.0, DARKER, FARTHER))
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onTertiary() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("on_tertiary")
            .setPalette((s) -> s.tertiaryPalette)
            .setBackground((s) -> s.platform == PHONE ? tertiary() : tertiaryDim())
            .setContrastCurve(
                (s) -> s.platform == PHONE ? getContrastCurve(6) : getContrastCurve(7))
            .build();
    return super.onTertiary().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor tertiaryContainer() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("tertiary_container")
            .setPalette((s) -> s.tertiaryPalette)
            .setTone(
                (s) -> {
                  if (s.platform == WATCH) {
                    return containerTone(s.tertiaryPalette, s.variant == TONAL_SPOT ? 90.0 : 100.0);
                  } else {
                    if (s.variant == NEUTRAL) {
                      return s.isDark
                          ? tMaxC(s.tertiaryPalette, 0, 93)
                          : tMaxC(s.tertiaryPalette, 0, 96);
                    } else if (s.variant == TONAL_SPOT) {
                      return tMaxC(s.tertiaryPalette, 0, s.isDark ? 93 : 100);
                    } else if (s.variant == EXPRESSIVE) {
                      return tMaxC(
                          s.tertiaryPalette,
                          /* lowerBound= */ 75,
                          /* upperBound= */ Hct.isCyan(s.tertiaryPalette.getHue())
                              ? 88
                              : (s.isDark ? 93 : 100));
                    } else { // VIBRANT
                      return s.isDark
                          ? tMaxC(s.tertiaryPalette, 0, 93)
                          : tMaxC(s.tertiaryPalette, 72, 100);
                    }
                  }
                })
            .setIsBackground(true)
            .setBackground(
                (s) -> {
                  if (s.platform == PHONE) {
                    return s.isDark ? surfaceBright() : surfaceDim();
                  } else {
                    return surfaceContainerHigh();
                  }
                })
            .setContrastCurve(
                (s) ->
                    s.platform == PHONE
                        ? (s.contrastLevel > 0 ? getContrastCurve(1.5) : null)
                        : new ContrastCurve(1.0, 1.0, 3.0, 4.5))
            .build();
    return super.tertiaryContainer().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onTertiaryContainer() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("on_tertiary_container")
            .setPalette((s) -> s.tertiaryPalette)
            .setBackground((s) -> tertiaryContainer())
            .setContrastCurve(
                (s) ->
                    s.platform == PHONE
                        ? getContrastCurve(6)
                        : new ContrastCurve(3.0, 7.0, 7.0, 11.0))
            .build();
    return super.onTertiaryContainer().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  ////////////////////////////////////////////////////////////////
  // Errors [E]                                                 //
  ////////////////////////////////////////////////////////////////

  @NonNull
  @Override
  public DynamicColor error() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("error")
            .setPalette((s) -> s.errorPalette)
            .setTone(
                (s) -> {
                  if (s.platform == PHONE) {
                    return s.isDark ? tMinC(s.errorPalette, 0, 98) : tMaxC(s.errorPalette);
                  } else {
                    double startingTone = DynamicColor.foregroundTone(25.0, /* ratio= */ 7.0);
                    return findDesiredChromaByTone(
                        s.errorPalette.getHue(), s.errorPalette.getChroma(), startingTone, 100.0);
                  }
                })
            .setIsBackground(true)
            .setBackground(
                (s) -> {
                  if (s.platform == PHONE) {
                    return s.isDark ? surfaceBright() : surfaceDim();
                  } else {
                    return surfaceContainerHigh();
                  }
                })
            .setContrastCurve(
                (s) ->
                    s.platform == PHONE
                        ? getContrastCurve(4.5)
                        : new ContrastCurve(3.0, 7.0, 7.0, 7.0))
            .setToneDeltaPair(
                (s) ->
                    s.platform == PHONE
                        ? new ToneDeltaPair(
                            errorContainer(), error(), 5.0, RELATIVE_LIGHTER, FARTHER)
                        : null)
            .build();
    return super.error().toBuilder().extendSpecVersion(SpecVersion.SPEC_2025, color2025).build();
  }

  @Nullable
  @Override
  public DynamicColor errorDim() {
    return new DynamicColor.Builder()
        .setName("error_dim")
        .setPalette((s) -> s.errorPalette)
        .setTone((s) -> tMinC(s.errorPalette))
        .setIsBackground(true)
        .setBackground((s) -> surfaceContainerHigh())
        .setContrastCurve((s) -> getContrastCurve(4.5))
        .setToneDeltaPair((s) -> new ToneDeltaPair(errorDim(), error(), 5.0, DARKER, FARTHER))
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onError() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("on_error")
            .setPalette((s) -> s.errorPalette)
            .setBackground((s) -> s.platform == PHONE ? error() : errorDim())
            .setContrastCurve(
                (s) ->
                    s.platform == PHONE
                        ? getContrastCurve(6)
                        : new ContrastCurve(4.5, 7.0, 11.0, 21.0))
            .build();
    return super.onError().toBuilder().extendSpecVersion(SpecVersion.SPEC_2025, color2025).build();
  }

  @NonNull
  @Override
  public DynamicColor errorContainer() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("error_container")
            .setPalette((s) -> s.errorPalette)
            .setTone(
                (s) -> {
                  if (s.platform == WATCH) {
                    return 30.0;
                  } else {
                    return s.isDark ? tMinC(s.errorPalette, 30, 93) : tMaxC(s.errorPalette, 0, 90);
                  }
                })
            .setIsBackground(true)
            .setBackground(
                (s) -> {
                  if (s.platform == PHONE) {
                    return s.isDark ? surfaceBright() : surfaceDim();
                  } else {
                    return surfaceContainerHigh();
                  }
                })
            .setToneDeltaPair(
                (s) ->
                    s.platform == WATCH
                        ? new ToneDeltaPair(errorContainer(), errorDim(), 10.0, DARKER, FARTHER)
                        : null)
            .setContrastCurve(
                (s) ->
                    s.platform == PHONE
                        ? (s.contrastLevel > 0 ? getContrastCurve(1.5) : null)
                        : new ContrastCurve(1.0, 1.0, 3.0, 4.5))
            .build();
    return super.errorContainer().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onErrorContainer() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("on_error_container")
            .setPalette((s) -> s.errorPalette)
            .setBackground((s) -> errorContainer())
            .setContrastCurve(
                (s) ->
                    s.platform == PHONE
                        ? getContrastCurve(4.5)
                        : new ContrastCurve(3.0, 7.0, 7.0, 11.0))
            .build();
    return super.onErrorContainer().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  ////////////////////////////////////////////////////////////////
  // Primary Fixed Colors [PF]                                  //
  ////////////////////////////////////////////////////////////////

  @NonNull
  @Override
  public DynamicColor primaryFixed() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("primary_fixed")
            .setPalette((s) -> s.primaryPalette)
            .setTone(
                (s) -> {
                  if (s.platform == WATCH) {
                    return s.variant == NEUTRAL
                        ? 90.0
                        : mainTone(s.primaryPalette, s.variant == TONAL_SPOT ? 90.0 : 100.0);
                  }
                  DynamicScheme tempS =
                      DynamicScheme.from(s, /* isDark= */ false, /* contrastLevel= */ 0.0);
                  return primaryContainer().getTone(tempS);
                })
            .setIsBackground(true)
            .setBackground(
                (s) -> {
                  if (s.platform == PHONE) {
                    return s.isDark ? surfaceBright() : surfaceDim();
                  } else {
                    return surfaceContainerHigh();
                  }
                })
            .setContrastCurve(
                (s) ->
                    s.platform == PHONE
                        ? (s.contrastLevel > 0 ? getContrastCurve(1.5) : null)
                        : new ContrastCurve(7.0, 7.0, 7.0, 7.0))
            .build();
    return super.primaryFixed().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor primaryFixedDim() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("primary_fixed_dim")
            .setPalette((s) -> s.primaryPalette)
            .setTone(
                (s) -> {
                  if (s.platform == WATCH) {
                    return s.variant == NEUTRAL
                        ? 85.0
                        : dimTone(s.primaryPalette, s.variant == TONAL_SPOT ? 90.0 : 100.0);
                  }
                  return primaryFixed().getTone(s);
                })
            .setIsBackground(true)
            .setBackground((s) -> s.platform == WATCH ? surfaceContainerHigh() : null)
            .setContrastCurve(
                (s) -> s.platform == WATCH ? new ContrastCurve(4.5, 4.5, 4.5, 4.5) : null)
            .setToneDeltaPair(
                (s) ->
                    s.platform == WATCH
                        ? null
                        : new ToneDeltaPair(primaryFixedDim(), primaryFixed(), 5.0, DARKER, EXACT))
            .build();
    return super.primaryFixedDim().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onPrimaryFixed() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("on_primary_fixed")
            .setPalette((s) -> s.primaryPalette)
            .setBackground((s) -> primaryFixedDim())
            .setSecondBackground((s) -> s.platform == WATCH ? primaryFixed() : null)
            .setContrastCurve(
                (s) ->
                    s.platform == WATCH
                        ? new ContrastCurve(4.5, 7.0, 11.0, 21.0)
                        : getContrastCurve(7))
            .build();
    return super.onPrimaryFixed().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onPrimaryFixedVariant() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("on_primary_fixed_variant")
            .setPalette((s) -> s.primaryPalette)
            .setTone(
                (s) ->
                    s.platform == WATCH
                        ? 30.0
                        : DynamicColor.getInitialToneFromBackground((scheme) -> primaryFixedDim())
                            .apply(s))
            .setBackground((s) -> primaryFixedDim())
            .setSecondBackground((s) -> s.platform == WATCH ? primaryFixed() : null)
            .setContrastCurve(
                (s) ->
                    s.platform == WATCH
                        ? new ContrastCurve(3.0, 4.5, 7.0, 11.0)
                        : getContrastCurve(4.5))
            .build();
    return super.onPrimaryFixedVariant().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  ////////////////////////////////////////////////////////////////
  // Secondary Fixed Colors [QF]                                //
  ////////////////////////////////////////////////////////////////

  @NonNull
  @Override
  public DynamicColor secondaryFixed() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("secondary_fixed")
            .setPalette((s) -> s.secondaryPalette)
            .setTone(
                (s) -> {
                  if (s.platform == WATCH) {
                    return s.variant == NEUTRAL ? 90.0 : mainTone(s.secondaryPalette, 90.0);
                  }
                  DynamicScheme tempS =
                      DynamicScheme.from(s, /* isDark= */ false, /* contrastLevel= */ 0.0);
                  return secondaryContainer().getTone(tempS);
                })
            .setIsBackground(true)
            .setBackground(
                (s) -> {
                  if (s.platform == PHONE) {
                    return s.isDark ? surfaceBright() : surfaceDim();
                  } else {
                    return surfaceContainerHigh();
                  }
                })
            .setContrastCurve(
                (s) ->
                    s.platform == PHONE
                        ? (s.contrastLevel > 0 ? getContrastCurve(1.5) : null)
                        : new ContrastCurve(7.0, 7.0, 7.0, 7.0))
            .build();
    return super.secondaryFixed().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor secondaryFixedDim() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("secondary_fixed_dim")
            .setPalette((s) -> s.secondaryPalette)
            .setTone(
                (s) -> {
                  if (s.platform == WATCH) {
                    return s.variant == NEUTRAL ? 85.0 : dimTone(s.secondaryPalette, 90.0);
                  }
                  return secondaryFixed().getTone(s);
                })
            .setIsBackground(true)
            .setBackground((s) -> s.platform == WATCH ? surfaceContainerHigh() : null)
            .setContrastCurve(
                (s) -> s.platform == WATCH ? new ContrastCurve(4.5, 4.5, 4.5, 4.5) : null)
            .setToneDeltaPair(
                (s) ->
                    s.platform == WATCH
                        ? null
                        : new ToneDeltaPair(
                            secondaryFixedDim(), secondaryFixed(), 5.0, DARKER, EXACT))
            .build();
    return super.secondaryFixedDim().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onSecondaryFixed() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("on_secondary_fixed")
            .setPalette((s) -> s.secondaryPalette)
            .setBackground((s) -> secondaryFixedDim())
            .setSecondBackground((s) -> s.platform == WATCH ? secondaryFixed() : null)
            .setContrastCurve(
                (s) ->
                    s.platform == WATCH
                        ? new ContrastCurve(4.5, 7.0, 11.0, 21.0)
                        : getContrastCurve(7))
            .build();
    return super.onSecondaryFixed().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onSecondaryFixedVariant() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("on_secondary_fixed_variant")
            .setPalette((s) -> s.secondaryPalette)
            .setTone(
                (s) ->
                    s.platform == WATCH
                        ? 30.0
                        : DynamicColor.getInitialToneFromBackground((scheme) -> secondaryFixedDim())
                            .apply(s))
            .setBackground((s) -> secondaryFixedDim())
            .setSecondBackground((s) -> s.platform == WATCH ? secondaryFixed() : null)
            .setContrastCurve(
                (s) ->
                    s.platform == WATCH
                        ? new ContrastCurve(3.0, 4.5, 7.0, 11.0)
                        : getContrastCurve(4.5))
            .build();
    return super.onSecondaryFixedVariant().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  ////////////////////////////////////////////////////////////////
  // Tertiary Fixed Colors [TF]                                 //
  ////////////////////////////////////////////////////////////////

  @NonNull
  @Override
  public DynamicColor tertiaryFixed() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("tertiary_fixed")
            .setPalette((s) -> s.tertiaryPalette)
            .setTone(
                (s) -> {
                  if (s.platform == WATCH) {
                    return mainTone(s.tertiaryPalette, s.variant == TONAL_SPOT ? 90.0 : 100.0);
                  }
                  DynamicScheme tempS =
                      DynamicScheme.from(s, /* isDark= */ false, /* contrastLevel= */ 0.0);
                  return tertiaryContainer().getTone(tempS);
                })
            .setIsBackground(true)
            .setBackground(
                (s) -> {
                  if (s.platform == PHONE) {
                    return s.isDark ? surfaceBright() : surfaceDim();
                  } else {
                    return surfaceContainerHigh();
                  }
                })
            .setContrastCurve(
                (s) ->
                    s.platform == PHONE
                        ? (s.contrastLevel > 0 ? getContrastCurve(1.5) : null)
                        : new ContrastCurve(7.0, 7.0, 7.0, 7.0))
            .build();
    return super.tertiaryFixed().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor tertiaryFixedDim() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("tertiary_fixed_dim")
            .setPalette((s) -> s.tertiaryPalette)
            .setTone(
                (s) ->
                    s.platform == WATCH
                        ? dimTone(s.tertiaryPalette, s.variant == TONAL_SPOT ? 90.0 : 100.0)
                        : tertiaryFixed().getTone(s))
            .setIsBackground(true)
            .setBackground((s) -> s.platform == WATCH ? surfaceContainerHigh() : null)
            .setContrastCurve(
                (s) -> s.platform == WATCH ? new ContrastCurve(4.5, 4.5, 4.5, 4.5) : null)
            .setToneDeltaPair(
                (s) ->
                    s.platform == WATCH
                        ? null
                        : new ToneDeltaPair(
                            tertiaryFixedDim(), tertiaryFixed(), 5.0, DARKER, EXACT))
            .build();
    return super.tertiaryFixedDim().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onTertiaryFixed() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("on_tertiary_fixed")
            .setPalette((s) -> s.tertiaryPalette)
            .setBackground((s) -> tertiaryFixedDim())
            .setSecondBackground((s) -> s.platform == WATCH ? tertiaryFixed() : null)
            .setContrastCurve(
                (s) ->
                    s.platform == WATCH
                        ? new ContrastCurve(4.5, 7.0, 11.0, 21.0)
                        : getContrastCurve(7))
            .build();
    return super.onTertiaryFixed().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onTertiaryFixedVariant() {
    DynamicColor color2025 =
        new DynamicColor.Builder()
            .setName("on_tertiary_fixed_variant")
            .setPalette((s) -> s.tertiaryPalette)
            .setTone(
                (s) ->
                    s.platform == WATCH
                        ? 30.0
                        : DynamicColor.getInitialToneFromBackground((scheme) -> tertiaryFixedDim())
                            .apply(s))
            .setBackground((s) -> tertiaryFixedDim())
            .setSecondBackground((s) -> s.platform == WATCH ? tertiaryFixed() : null)
            .setContrastCurve(
                (s) ->
                    s.platform == WATCH
                        ? new ContrastCurve(3.0, 4.5, 7.0, 11.0)
                        : getContrastCurve(4.5))
            .build();
    return super.onTertiaryFixedVariant().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  //////////////////////////////////////////////////////////////////
  // Android-only Colors                                          //
  //////////////////////////////////////////////////////////////////

  @NonNull
  @Override
  public DynamicColor controlActivated() {
    // Remapped to primaryContainer for 2025 spec.
    DynamicColor color2025 = primaryContainer().toBuilder().setName("control_activated").build();
    return super.controlActivated().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor controlNormal() {
    // Remapped to onSurfaceVariant for 2025 spec.
    DynamicColor color2025 = onSurfaceVariant().toBuilder().setName("control_normal").build();
    return super.controlNormal().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor textPrimaryInverse() {
    // Remapped to inverseOnSurface for 2025 spec.
    DynamicColor color2025 = inverseOnSurface().toBuilder().setName("text_primary_inverse").build();
    return super.textPrimaryInverse().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2025, color2025)
        .build();
  }

  ////////////////////////////////////////////////////////////////
  // Other                                                      //
  ////////////////////////////////////////////////////////////////

  private static boolean isCloseToChroma(Hct hct, double chroma) {
    return Math.abs(hct.getChroma() - chroma) < 0.4;
  }

  private static double findDesiredChromaByTone(
      double hue, double chroma, double startingTone, double endingTone) {
    if (endingTone == startingTone) {
      return startingTone;
    }

    double answer = startingTone;
    double potentialAnswer = answer;

    Hct closestToChroma = Hct.from(hue, chroma, startingTone);
    if (closestToChroma.getChroma() < chroma && !isCloseToChroma(closestToChroma, chroma)) {
      while (closestToChroma.getChroma() < chroma) {
        double increment = endingTone < startingTone ? -1.0 : 1.0;
        potentialAnswer += increment;
        if (potentialAnswer < endingTone && endingTone < startingTone) {
          return answer;
        } else if (potentialAnswer > endingTone && endingTone > startingTone) {
          return answer;
        }
        Hct potentialSolution = Hct.from(hue, chroma, potentialAnswer);
        if (isCloseToChroma(potentialSolution, chroma)) {
          return potentialAnswer;
        }

        double potentialDelta = Math.abs(potentialSolution.getChroma() - chroma);
        double currentDelta = Math.abs(closestToChroma.getChroma() - chroma);
        if (potentialDelta < currentDelta) {
          closestToChroma = potentialSolution;
          answer = potentialAnswer;
        }
      }
    }

    return answer;
  }

  private static double mainTone(TonalPalette tonalPalette, double maxTone) {
    double initialTone = maxTone;
    double endingTone = DynamicColor.foregroundTone(25.0, /* ratio= */ 7.0);
    return findDesiredChromaByTone(
        tonalPalette.getHue(), tonalPalette.getChroma(), initialTone, endingTone);
  }

  private static double dimTone(TonalPalette tonalPalette, double maxTone) {
    double initialTone = min(mainTone(tonalPalette, maxTone) - 5.0, maxTone);
    double endingTone = DynamicColor.foregroundTone(25.0, /* ratio= */ 4.5);
    return findDesiredChromaByTone(
        tonalPalette.getHue(), tonalPalette.getChroma(), initialTone, endingTone);
  }

  private static double containerTone(TonalPalette tonalPalette, double maxTone) {
    double initialTone = min(dimTone(tonalPalette, maxTone) - 5.0, maxTone);
    double endingTone = DynamicColor.foregroundTone(0.0, /* ratio= */ 7.0);
    return findDesiredChromaByTone(
        tonalPalette.getHue(), tonalPalette.getChroma(), initialTone, endingTone);
  }

  private static double findBestToneForChroma(
      double hue, double chroma, double tone, boolean byDecreasingTone) {
    double answer = tone;
    Hct bestCandidate = Hct.from(hue, chroma, answer);
    while (bestCandidate.getChroma() < chroma) {
      if (tone < 0 || tone > 100) {
        break;
      }
      tone += byDecreasingTone ? -1.0 : 1.0;
      Hct newCandidate = Hct.from(hue, chroma, tone);
      if (bestCandidate.getChroma() < newCandidate.getChroma()) {
        bestCandidate = newCandidate;
        answer = tone;
      }
    }
    return answer;
  }

  private static double tMaxC(TonalPalette palette) {
    return tMaxC(palette, 0, 100);
  }

  private static double tMaxC(TonalPalette palette, double lowerBound, double upperBound) {
    return tMaxC(palette, lowerBound, upperBound, 1);
  }

  private static double tMaxC(
      TonalPalette palette, double lowerBound, double upperBound, double chromaMultiplier) {
    double answer =
        findBestToneForChroma(palette.getHue(), palette.getChroma() * chromaMultiplier, 100, true);
    return MathUtils.clampDouble(lowerBound, upperBound, answer);
  }

  private static double tMinC(TonalPalette palette) {
    return tMinC(palette, 0, 100);
  }

  private static double tMinC(TonalPalette palette, double lowerBound, double upperBound) {
    double answer = findBestToneForChroma(palette.getHue(), palette.getChroma(), 0, false);
    return MathUtils.clampDouble(lowerBound, upperBound, answer);
  }

  private static ContrastCurve getContrastCurve(double defaultContrast) {
    if (defaultContrast == 1.5) {
      return new ContrastCurve(1.5, 1.5, 3, 5.5);
    } else if (defaultContrast == 3) {
      return new ContrastCurve(3, 3, 4.5, 7);
    } else if (defaultContrast == 4.5) {
      return new ContrastCurve(4.5, 4.5, 7, 11);
    } else if (defaultContrast == 6) {
      return new ContrastCurve(6, 6, 7, 11);
    } else if (defaultContrast == 7) {
      return new ContrastCurve(7, 7, 11, 21);
    } else if (defaultContrast == 9) {
      return new ContrastCurve(9, 9, 11, 21);
    } else if (defaultContrast == 11) {
      return new ContrastCurve(11, 11, 21, 21);
    } else if (defaultContrast == 21) {
      return new ContrastCurve(21, 21, 21, 21);
    } else {
      // Shouldn't happen.
      return new ContrastCurve(defaultContrast, defaultContrast, 7, 21);
    }
  }

  /////////////////////////////////////////////////////////////////
  // Color value calculations                                    //
  /////////////////////////////////////////////////////////////////

  @NonNull
  @Override
  public Hct getHct(DynamicScheme scheme, DynamicColor color) {
    // This is crucial for aesthetics: we aren't simply taking the standard color
    // and changing its tone for contrast. Rather, we find the tone for contrast, then
    // use the specified chroma from the palette to construct a new color.
    //
    // For example, this enables colors with standard tone of T90, which has limited chroma, to
    // "recover" intended chroma as contrast increases.
    TonalPalette palette = color.palette.apply(scheme);
    double tone = getTone(scheme, color);
    double chromaMultiplier =
        color.chromaMultiplier == null ? 1.0 : color.chromaMultiplier.apply(scheme);
    if (chromaMultiplier == 1.0) {
      return palette.getHct(tone);
    }

    double chroma = palette.getChroma() * chromaMultiplier;
    if (tone == 99.0 && Hct.isYellow(palette.getHue())) {
      return TonalPalette.fromHueAndChroma(palette.getHue(), chroma).getHct(tone);
    }
    return Hct.from(palette.getHue(), chroma, tone);
  }

  @Override
  public double getTone(DynamicScheme scheme, DynamicColor color) {
    ToneDeltaPair toneDeltaPair =
        color.toneDeltaPair == null ? null : color.toneDeltaPair.apply(scheme);

    // Case 0: tone delta pair.
    if (toneDeltaPair != null) {
      DynamicColor roleA = toneDeltaPair.getRoleA();
      DynamicColor roleB = toneDeltaPair.getRoleB();
      TonePolarity polarity = toneDeltaPair.getPolarity();
      DeltaConstraint constraint = toneDeltaPair.getConstraint();
      double absoluteDelta =
          polarity == TonePolarity.DARKER
                  || (polarity == TonePolarity.RELATIVE_LIGHTER && scheme.isDark)
                  || (polarity == TonePolarity.RELATIVE_DARKER && !scheme.isDark)
              ? -toneDeltaPair.getDelta()
              : toneDeltaPair.getDelta();

      boolean amRoleA = color.name.equals(roleA.name);
      DynamicColor selfRole = amRoleA ? roleA : roleB;
      DynamicColor referenceRole = amRoleA ? roleB : roleA;
      double selfTone = selfRole.tone.apply(scheme);
      double referenceTone = referenceRole.getTone(scheme);
      double relativeDelta = absoluteDelta * (amRoleA ? 1 : -1);

      switch (constraint) {
        case EXACT -> selfTone = MathUtils.clampDouble(0, 100, referenceTone + relativeDelta);
        case NEARER -> {
          if (relativeDelta > 0) {
            selfTone =
                MathUtils.clampDouble(
                    0,
                    100,
                    MathUtils.clampDouble(referenceTone, referenceTone + relativeDelta, selfTone));
          } else {
            selfTone =
                MathUtils.clampDouble(
                    0,
                    100,
                    MathUtils.clampDouble(referenceTone + relativeDelta, referenceTone, selfTone));
          }
        }
        case FARTHER -> {
          if (relativeDelta > 0) {
            selfTone = MathUtils.clampDouble(referenceTone + relativeDelta, 100, selfTone);
          } else {
            selfTone = MathUtils.clampDouble(0, referenceTone + relativeDelta, selfTone);
          }
        }
      }

      if (color.background != null && color.contrastCurve != null) {
        DynamicColor background = color.background.apply(scheme);
        ContrastCurve contrastCurve = color.contrastCurve.apply(scheme);
        if (background != null && contrastCurve != null) {
          double bgTone = background.getTone(scheme);
          double selfContrast = contrastCurve.get(scheme.contrastLevel);
          selfTone =
              Contrast.ratioOfTones(bgTone, selfTone) >= selfContrast && scheme.contrastLevel >= 0
                  ? selfTone
                  : DynamicColor.foregroundTone(bgTone, selfContrast);
        }
      }

      // This can avoid the awkward tones for background colors including the access fixed colors.
      // Accent fixed dim colors should not be adjusted.
      if (scheme.platform == PHONE && color.isBackground && !color.name.endsWith("_fixed_dim")) {
        if (selfTone >= 57) {
          selfTone = MathUtils.clampDouble(65, 100, selfTone);
        } else {
          selfTone = MathUtils.clampDouble(0, 49, selfTone);
        }
      }

      return selfTone;
    } else {
      // Case 1: No tone delta pair; just solve for itself.
      double answer = color.tone.apply(scheme);

      if (color.background == null
          || color.background.apply(scheme) == null
          || color.contrastCurve == null
          || color.contrastCurve.apply(scheme) == null) {
        return answer; // No adjustment for colors with no background.
      }

      double bgTone = color.background.apply(scheme).getTone(scheme);
      double desiredRatio = color.contrastCurve.apply(scheme).get(scheme.contrastLevel);

      // Recalculate the tone from desired contrast ratio if the current
      // contrast ratio is not enough or desired contrast level is decreasing
      // (<0).
      answer =
          Contrast.ratioOfTones(bgTone, answer) >= desiredRatio && scheme.contrastLevel >= 0
              ? answer
              : DynamicColor.foregroundTone(bgTone, desiredRatio);

      // This can avoid the awkward tones for background colors including the access fixed colors.
      // Accent fixed dim colors should not be adjusted.
      if (scheme.platform == PHONE && color.isBackground && !color.name.endsWith("_fixed_dim")) {
        if (answer >= 57) {
          answer = MathUtils.clampDouble(65, 100, answer);
        } else {
          answer = MathUtils.clampDouble(0, 49, answer);
        }
      } else if (scheme.platform == WATCH && color.isBackground && 50 <= answer && answer < 60) {
        if (Contrast.ratioOfTones(49, bgTone) >= desiredRatio) {
          answer = 49;
        } else {
          answer = 60;
        }
      }

      if (color.secondBackground == null || color.secondBackground.apply(scheme) == null) {
        return answer;
      }

      // Case 2: Adjust for dual backgrounds.
      double bgTone1 = color.background.apply(scheme).getTone(scheme);
      double bgTone2 = color.secondBackground.apply(scheme).getTone(scheme);
      double upper = max(bgTone1, bgTone2);
      double lower = min(bgTone1, bgTone2);

      if (Contrast.ratioOfTones(upper, answer) >= desiredRatio
          && Contrast.ratioOfTones(lower, answer) >= desiredRatio) {
        return answer;
      }

      // The darkest light tone that satisfies the desired ratio,
      // or -1 if such ratio cannot be reached.
      double lightOption = Contrast.lighter(upper, desiredRatio);

      // The lightest dark tone that satisfies the desired ratio,
      // or -1 if such ratio cannot be reached.
      double darkOption = Contrast.darker(lower, desiredRatio);

      // Tones suitable for the foreground.
      ArrayList<Double> availables = new ArrayList<>();
      if (lightOption != -1) {
        availables.add(lightOption);
      }
      if (darkOption != -1) {
        availables.add(darkOption);
      }

      boolean prefersLight =
          DynamicColor.tonePrefersLightForeground(bgTone1)
              || DynamicColor.tonePrefersLightForeground(bgTone2);
      if (prefersLight) {
        return (lightOption < 0) ? 100 : lightOption;
      }
      if (availables.size() == 1) {
        return availables.get(0);
      }
      return (darkOption < 0) ? 0 : darkOption;
    }
  }

  //////////////////////////////////////////////////////////////////
  // Scheme Palettes                                              //
  //////////////////////////////////////////////////////////////////

  @NonNull
  @Override
  public TonalPalette getPrimaryPalette(
      Variant variant,
      Hct sourceColorHct,
      boolean isDark,
      Platform platform,
      double contrastLevel) {
    return switch (variant) {
      case NEUTRAL ->
          TonalPalette.fromHueAndChroma(
              sourceColorHct.getHue(),
              platform == PHONE
                  ? (Hct.isBlue(sourceColorHct.getHue()) ? 12 : 8)
                  : (isWatchBlueHue(sourceColorHct) ? 16 : 12));
      case TONAL_SPOT ->
          TonalPalette.fromHueAndChroma(
              sourceColorHct.getHue(), platform == PHONE && isDark ? 26 : 32);
      case EXPRESSIVE ->
          TonalPalette.fromHueAndChroma(
              sourceColorHct.getHue(), platform == PHONE ? (isDark ? 36 : 48) : 40);
      case VIBRANT ->
          TonalPalette.fromHueAndChroma(sourceColorHct.getHue(), platform == PHONE ? 74 : 48);
      case CONTENT ->
          platform == WATCH
              ? TonalPalette.fromHueAndChroma(sourceColorHct.getHue(), sourceColorHct.getChroma())
              : super.getPrimaryPalette(variant, sourceColorHct, isDark, platform, contrastLevel);
      default -> super.getPrimaryPalette(variant, sourceColorHct, isDark, platform, contrastLevel);
    };
  }

  @NonNull
  @Override
  public TonalPalette getSecondaryPalette(
      Variant variant,
      Hct sourceColorHct,
      boolean isDark,
      Platform platform,
      double contrastLevel) {
    return switch (variant) {
      case NEUTRAL ->
          TonalPalette.fromHueAndChroma(
              sourceColorHct.getHue(),
              platform == PHONE
                  ? (Hct.isBlue(sourceColorHct.getHue()) ? 6 : 4)
                  : (isWatchBlueHue(sourceColorHct) ? 10 : 6));
      case TONAL_SPOT -> TonalPalette.fromHueAndChroma(sourceColorHct.getHue(), 16);
      case EXPRESSIVE ->
          TonalPalette.fromHueAndChroma(
              platform == WATCH
                  ? DynamicScheme.getRotatedHue(
                      sourceColorHct,
                      new double[] {0, 21, 51, 121, 151, 191, 271, 321, 360},
                      new double[] {204, 175, 155, 150, 204, 260, 204, 204, 204})
                  : DynamicScheme.getRotatedHue(
                      sourceColorHct,
                      new double[] {0, 105, 140, 204, 253, 278, 300, 333, 360},
                      new double[] {-160, 155, -100, 96, -96, -156, -165, -160}),
              platform == PHONE ? (isDark ? 16 : 24) : 24);
      case VIBRANT ->
          TonalPalette.fromHueAndChroma(
              platform == WATCH
                  ? DynamicScheme.getRotatedHue(
                      sourceColorHct,
                      new double[] {0, 41, 61, 101, 131, 181, 251, 301, 360},
                      new double[] {-14, 0, 355, 357, 0, 3, 10, 331, 331})
                  : DynamicScheme.getRotatedHue(
                      sourceColorHct,
                      new double[] {0, 38, 105, 140, 333, 360},
                      new double[] {-14, 10, -14, 10, -14}),
              platform == PHONE ? 56 : 36);
      case CONTENT ->
          platform == WATCH
              ? TonalPalette.fromHueAndChroma(
                  sourceColorHct.getHue(),
                  MathUtils.clampDouble(16.0, 36.0, sourceColorHct.getChroma() * 0.5))
              : super.getSecondaryPalette(variant, sourceColorHct, isDark, platform, contrastLevel);
      default ->
          super.getSecondaryPalette(variant, sourceColorHct, isDark, platform, contrastLevel);
    };
  }

  @NonNull
  @Override
  public TonalPalette getTertiaryPalette(
      Variant variant,
      Hct sourceColorHct,
      boolean isDark,
      Platform platform,
      double contrastLevel) {
    return switch (variant) {
      case NEUTRAL ->
          TonalPalette.fromHueAndChroma(
              platform == WATCH
                  ? DynamicScheme.getRotatedHue(
                      sourceColorHct,
                      new double[] {0, 41, 61, 101, 131, 181, 250, 270, 360},
                      new double[] {25, 25, 26, 25, -39, 25, 28, 25, 25})
                  : DynamicScheme.getRotatedHue(
                      sourceColorHct,
                      new double[] {0, 38, 105, 161, 204, 278, 333, 360},
                      new double[] {-32, 26, 10, -39, 24, -15, -32}),
              platform == PHONE ? 20 : 36);
      case TONAL_SPOT ->
          TonalPalette.fromHueAndChroma(
              platform == WATCH
                  ? DynamicScheme.getRotatedHue(
                      sourceColorHct,
                      new double[] {0, 40, 101, 210, 301, 360},
                      new double[] {-32, 32, -32, 32, -32, -32})
                  : DynamicScheme.getRotatedHue(
                      sourceColorHct,
                      new double[] {0, 20, 71, 161, 333, 360},
                      new double[] {-40, 48, -32, 40, -32}),
              platform == PHONE ? 28 : 32);
      case EXPRESSIVE ->
          TonalPalette.fromHueAndChroma(
              platform == WATCH
                  ? DynamicScheme.getRotatedHue(
                      sourceColorHct,
                      new double[] {0, 21, 51, 121, 151, 191, 271, 321, 360},
                      new double[] {200, 200, 160, 169, 200, 220, 200, 200, 200})
                  : DynamicScheme.getRotatedHue(
                      sourceColorHct,
                      new double[] {0, 105, 140, 204, 253, 278, 300, 333, 360},
                      new double[] {-165, 160, -105, 101, -101, -160, -170, -165}),
              48);
      case VIBRANT ->
          TonalPalette.fromHueAndChroma(
              platform == WATCH
                  ? DynamicScheme.getRotatedHue(
                      sourceColorHct,
                      new double[] {0, 41, 61, 101, 131, 181, 251, 301, 360},
                      new double[] {-72, 55, 45, 50, 55, 50, 62, 303, 303})
                  : DynamicScheme.getRotatedHue(
                      sourceColorHct,
                      new double[] {0, 38, 71, 105, 140, 161, 253, 333, 360},
                      new double[] {-72, 35, 24, -24, 62, 50, 62, -72}),
              platform == PHONE ? 56 : 48);
      case CONTENT ->
          platform == WATCH
              ? TonalPalette.fromHueAndChroma(
                  DynamicScheme.getRotatedHue(
                      sourceColorHct,
                      new double[] {0, 40, 101, 210, 301, 360},
                      new double[] {-32, 32, -32, 32, -32, -32}),
                  sourceColorHct.getChroma())
              : super.getTertiaryPalette(variant, sourceColorHct, isDark, platform, contrastLevel);
      default -> super.getTertiaryPalette(variant, sourceColorHct, isDark, platform, contrastLevel);
    };
  }

  @NonNull
  @Override
  public TonalPalette getNeutralPalette(
      Variant variant,
      Hct sourceColorHct,
      boolean isDark,
      Platform platform,
      double contrastLevel) {
    return switch (variant) {
      case NEUTRAL ->
          TonalPalette.fromHueAndChroma(sourceColorHct.getHue(), platform == PHONE ? 1.4 : 6);
      case TONAL_SPOT ->
          TonalPalette.fromHueAndChroma(sourceColorHct.getHue(), platform == PHONE ? 5 : 10);
      case EXPRESSIVE ->
          TonalPalette.fromHueAndChroma(
              getExpressiveNeutralHue(sourceColorHct, platform),
              getExpressiveNeutralChroma(sourceColorHct, isDark, platform));
      case VIBRANT ->
          TonalPalette.fromHueAndChroma(
              getVibrantNeutralHue(sourceColorHct, platform),
              getVibrantNeutralChroma(sourceColorHct, platform));
      case CONTENT ->
          platform == WATCH
              ? TonalPalette.fromHueAndChroma(
                  sourceColorHct.getHue(),
                  MathUtils.clampDouble(6.0, 20.0, sourceColorHct.getChroma() * 0.333))
              : super.getNeutralPalette(variant, sourceColorHct, isDark, platform, contrastLevel);
      default -> super.getNeutralPalette(variant, sourceColorHct, isDark, platform, contrastLevel);
    };
  }

  @NonNull
  @Override
  public TonalPalette getNeutralVariantPalette(
      Variant variant,
      Hct sourceColorHct,
      boolean isDark,
      Platform platform,
      double contrastLevel) {
    if (platform == WATCH) {
      return switch (variant) {
        case NEUTRAL, TONAL_SPOT, EXPRESSIVE, VIBRANT, CONTENT ->
            getNeutralPalette(variant, sourceColorHct, isDark, platform, contrastLevel);
        default ->
            super.getNeutralVariantPalette(
                variant, sourceColorHct, isDark, platform, contrastLevel);
      };
    }
    switch (variant) {
      case NEUTRAL -> {
        return TonalPalette.fromHueAndChroma(
            sourceColorHct.getHue(), (platform == PHONE ? 1.4 : 6) * 2.2);
      }
      case TONAL_SPOT -> {
        return TonalPalette.fromHueAndChroma(
            sourceColorHct.getHue(), (platform == PHONE ? 5 : 10) * 1.7);
      }
      case EXPRESSIVE -> {
        double expressiveNeutralHue = getExpressiveNeutralHue(sourceColorHct, platform);
        double expressiveNeutralChroma =
            getExpressiveNeutralChroma(sourceColorHct, isDark, platform);
        return TonalPalette.fromHueAndChroma(
            expressiveNeutralHue,
            expressiveNeutralChroma
                * (expressiveNeutralHue >= 105 && expressiveNeutralHue < 125 ? 1.6 : 2.3));
      }
      case VIBRANT -> {
        double vibrantNeutralHue = getVibrantNeutralHue(sourceColorHct, platform);
        double vibrantNeutralChroma = getVibrantNeutralChroma(sourceColorHct, platform);
        return TonalPalette.fromHueAndChroma(vibrantNeutralHue, vibrantNeutralChroma * 1.29);
      }
      default -> {
        return super.getNeutralVariantPalette(
            variant, sourceColorHct, isDark, platform, contrastLevel);
      }
    }
  }

  @NonNull
  @Override
  public Optional<TonalPalette> getErrorPalette(
      Variant variant,
      Hct sourceColorHct,
      boolean isDark,
      Platform platform,
      double contrastLevel) {
    double errorHue =
        DynamicScheme.getPiecewiseValue(
            sourceColorHct,
            new double[] {0, 3, 13, 23, 33, 43, 153, 273, 360},
            new double[] {12, 22, 32, 12, 22, 32, 22, 12});
    return switch (variant) {
      case NEUTRAL ->
          Optional.of(TonalPalette.fromHueAndChroma(errorHue, platform == PHONE ? 50 : 40));
      case TONAL_SPOT ->
          Optional.of(TonalPalette.fromHueAndChroma(errorHue, platform == PHONE ? 60 : 48));
      case EXPRESSIVE ->
          Optional.of(TonalPalette.fromHueAndChroma(errorHue, platform == PHONE ? 64 : 48));
      case VIBRANT ->
          Optional.of(TonalPalette.fromHueAndChroma(errorHue, platform == PHONE ? 80 : 48));
      case CONTENT ->
          platform == WATCH
              ? Optional.of(
                  TonalPalette.fromHueAndChroma(errorHue, max(40.0, sourceColorHct.getChroma())))
              : super.getErrorPalette(variant, sourceColorHct, isDark, platform, contrastLevel);
      default -> super.getErrorPalette(variant, sourceColorHct, isDark, platform, contrastLevel);
    };
  }

  private static boolean isWatchBlueHue(Hct sourceColorHct) {
    return 250 <= sourceColorHct.getHue() && sourceColorHct.getHue() <= 270;
  }

  private static double getExpressiveNeutralHue(Hct sourceColorHct, Platform platform) {
    if (platform == WATCH) {
      return DynamicScheme.getRotatedHue(
          sourceColorHct,
          new double[] {0, 21, 51, 121, 151, 191, 271, 321, 360},
          new double[] {0, 0, 0, 0, 0, 0, 10, 0, 0});
    }
    return DynamicScheme.getRotatedHue(
        sourceColorHct,
        new double[] {0, 71, 124, 253, 278, 300, 360},
        new double[] {10, 0, 10, 0, 10, 0});
  }

  private static double getExpressiveNeutralChroma(
      Hct sourceColorHct, boolean isDark, Platform platform) {
    double neutralHue = getExpressiveNeutralHue(sourceColorHct, platform);
    return platform == PHONE ? (isDark ? (Hct.isYellow(neutralHue) ? 6 : 14) : 18) : 12;
  }

  private static double getVibrantNeutralHue(Hct sourceColorHct, Platform platform) {
    if (platform == WATCH) {
      return DynamicScheme.getRotatedHue(
          sourceColorHct,
          new double[] {0, 41, 61, 101, 131, 181, 251, 301, 360},
          new double[] {-14, 0, 355, 357, 0, 3, 10, 331, 331});
    }
    return DynamicScheme.getRotatedHue(
        sourceColorHct,
        new double[] {0, 38, 105, 140, 333, 360},
        new double[] {-14, 10, -14, 10, -14});
  }

  private static double getVibrantNeutralChroma(Hct sourceColorHct, Platform platform) {
    return platform == PHONE ? 28 : (isWatchBlueHue(sourceColorHct) ? 28 : 20);
  }
}
