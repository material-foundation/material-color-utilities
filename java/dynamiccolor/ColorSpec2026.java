/*
 * Copyright 2026 Google LLC
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

import static dynamiccolor.ToneDeltaPair.DeltaConstraint.EXACT;
import static dynamiccolor.ToneDeltaPair.DeltaConstraint.FARTHER;
import static dynamiccolor.TonePolarity.DARKER;
import static dynamiccolor.TonePolarity.RELATIVE_LIGHTER;

import androidx.annotation.NonNull;
import hct.Hct;
import palettes.TonalPalette;
import utils.MathUtils;

final class ColorSpec2026 extends ColorSpec2025 {

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

  @NonNull
  @Override
  public DynamicColor surface() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("surface")
            .setPalette(s -> s.neutralPalette)
            .setTone(
                s -> {
                  if (s.variant == Variant.CMF) {
                    return s.isDark ? 4.0 : 98.0;
                  } else { // Undefined use case
                    return 0.0;
                  }
                })
            .setIsBackground(true)
            .build();
    return super.surface().toBuilder().extendSpecVersion(SpecVersion.SPEC_2026, color2026).build();
  }

  @NonNull
  @Override
  public DynamicColor surfaceDim() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("surface_dim")
            .setPalette(s -> s.neutralPalette)
            .setTone(
                s -> {
                  if (s.variant == Variant.CMF) {
                    return s.isDark ? 4.0 : 87.0;
                  } else { // Undefined use case
                    return 0.0;
                  }
                })
            .setChromaMultiplier(
                s -> {
                  if (s.variant == Variant.CMF) {
                    return s.isDark ? 1.0 : 1.7;
                  } else { // Undefined use case
                    return 0.0;
                  }
                })
            .setIsBackground(true)
            .build();
    return super.surfaceDim().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor surfaceBright() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("surface_bright")
            .setPalette(s -> s.neutralPalette)
            .setTone(
                s -> {
                  if (s.variant == Variant.CMF) {
                    return s.isDark ? 18.0 : 98.0;
                  } else { // Undefined use case
                    return 0.0;
                  }
                })
            .setChromaMultiplier(
                s -> {
                  if (s.variant == Variant.CMF) {
                    return s.isDark ? 1.7 : 1.0;
                  } else { // Undefined use case
                    return 0.0;
                  }
                })
            .setIsBackground(true)
            .build();
    return super.surfaceBright().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor surfaceContainerLowest() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("surface_container_lowest")
            .setPalette(s -> s.neutralPalette)
            .setTone(
                s -> {
                  if (s.variant == Variant.CMF) {
                    return s.isDark ? 0.0 : 100.0;
                  } else { // Undefined use case
                    return 0.0;
                  }
                })
            .setIsBackground(true)
            .build();
    return super.surfaceContainerLowest().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor surfaceContainerLow() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("surface_container_low")
            .setPalette(s -> s.neutralPalette)
            .setTone(
                s -> {
                  if (s.variant == Variant.CMF) {
                    return s.isDark ? 6.0 : 96.0;
                  } else { // Undefined use case
                    return 0.0;
                  }
                })
            .setChromaMultiplier(
                s -> {
                  if (s.variant == Variant.CMF) {
                    return 1.25;
                  } else { // Undefined use case
                    return 0.0;
                  }
                })
            .setIsBackground(true)
            .build();
    return super.surfaceContainerLow().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor surfaceContainer() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("surface_container")
            .setPalette(s -> s.neutralPalette)
            .setTone(
                s -> {
                  if (s.variant == Variant.CMF) {
                    return s.isDark ? 9.0 : 94.0;
                  } else { // Undefined use case
                    return 0.0;
                  }
                })
            .setChromaMultiplier(
                s -> {
                  if (s.variant == Variant.CMF) {
                    return 1.4;
                  } else { // Undefined use case
                    return 0.0;
                  }
                })
            .setIsBackground(true)
            .build();
    return super.surfaceContainer().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor surfaceContainerHigh() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("surface_container_high")
            .setPalette(s -> s.neutralPalette)
            .setTone(
                s -> {
                  if (s.variant == Variant.CMF) {
                    return s.isDark ? 12.0 : 92.0;
                  } else { // Undefined use case
                    return 0.0;
                  }
                })
            .setChromaMultiplier(
                s -> {
                  if (s.variant == Variant.CMF) {
                    return 1.5;
                  } else { // Undefined use case
                    return 0.0;
                  }
                })
            .setIsBackground(true)
            .build();
    return super.surfaceContainerHigh().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor surfaceContainerHighest() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("surface_container_highest")
            .setPalette(s -> s.neutralPalette)
            .setTone(
                s -> {
                  if (s.variant == Variant.CMF) {
                    return s.isDark ? 15.0 : 90.0;
                  } else { // Undefined use case
                    return 0.0;
                  }
                })
            .setChromaMultiplier(
                s -> {
                  if (s.variant == Variant.CMF) {
                    return 1.7;
                  } else { // Undefined use case
                    return 0.0;
                  }
                })
            .setIsBackground(true)
            .build();
    return super.surfaceContainerHighest().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onSurface() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("on_surface")
            .setPalette(s -> s.neutralPalette)
            .setChromaMultiplier(
                s -> {
                  if (s.variant == Variant.CMF) {
                    return 1.7;
                  } else { // Undefined use case
                    return 0.0;
                  }
                })
            .setBackground(s -> highestSurface(s))
            .setContrastCurve(s -> s.isDark ? getContrastCurve(11) : getContrastCurve(9))
            .build();
    return super.onSurface().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onSurfaceVariant() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("on_surface_variant")
            .setPalette(s -> s.neutralPalette)
            .setChromaMultiplier(
                s -> {
                  if (s.variant == Variant.CMF) {
                    return 1.7;
                  } else { // Undefined variant
                    return 0.0;
                  }
                })
            .setBackground(s -> highestSurface(s))
            .setContrastCurve(s -> s.isDark ? getContrastCurve(6) : getContrastCurve(4.5))
            .build();
    return super.onSurfaceVariant().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor outline() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("outline")
            .setPalette(s -> s.neutralPalette)
            .setChromaMultiplier(
                s -> {
                  if (s.variant == Variant.CMF) {
                    return 1.7;
                  } else { // Undefined use case
                    return 0.0;
                  }
                })
            .setBackground(s -> highestSurface(s))
            .setContrastCurve(s -> getContrastCurve(3))
            .build();
    return super.outline().toBuilder().extendSpecVersion(SpecVersion.SPEC_2026, color2026).build();
  }

  @NonNull
  @Override
  public DynamicColor outlineVariant() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("outline_variant")
            .setPalette(s -> s.neutralPalette)
            .setChromaMultiplier(
                s -> {
                  if (s.variant == Variant.CMF) {
                    return 1.7;
                  } else { // Undefined use case
                    return 0.0;
                  }
                })
            .setBackground(s -> highestSurface(s))
            .setContrastCurve(s -> getContrastCurve(1.5))
            .build();
    return super.outlineVariant().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor inverseSurface() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("inverse_surface")
            .setPalette(s -> s.neutralPalette)
            .setTone(s -> s.isDark ? 98.0 : 4.0)
            .setChromaMultiplier(
                s -> {
                  if (s.variant == Variant.CMF) {
                    return 1.7;
                  } else { // Undefined use case
                    return 0.0;
                  }
                })
            .setIsBackground(true)
            .build();
    return super.inverseSurface().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor inverseOnSurface() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("inverse_on_surface")
            .setPalette(s -> s.neutralPalette)
            .setBackground(s -> inverseSurface())
            .setContrastCurve(s -> getContrastCurve(7))
            .build();
    return super.inverseOnSurface().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor primary() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("primary")
            .setPalette(s -> s.primaryPalette)
            .setTone(
                s ->
                    s.sourceColorHct.getChroma() <= 12
                        ? (s.isDark ? 80.0 : 40.0)
                        : s.sourceColorHct.getTone())
            .setIsBackground(true)
            .setBackground(s -> highestSurface(s))
            .setContrastCurve(s -> getContrastCurve(4.5))
            .setToneDeltaPair(
                s ->
                    s.platform == DynamicScheme.Platform.PHONE
                        ? new ToneDeltaPair(
                            primaryContainer(), primary(), 5, RELATIVE_LIGHTER, FARTHER)
                        : null)
            .build();
    return super.primary().toBuilder().extendSpecVersion(SpecVersion.SPEC_2026, color2026).build();
  }

  @NonNull
  @Override
  public DynamicColor primaryDim() {
    // Remapped to primary in 2026 spec.
    DynamicColor color2026 = primary().toBuilder().setName("primary_dim").build();
    return super.primaryDim().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onPrimary() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("on_primary")
            .setPalette(s -> s.primaryPalette)
            .setBackground(s -> primary())
            .setContrastCurve(s -> getContrastCurve(6))
            .build();
    return super.onPrimary().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor primaryContainer() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("primary_container")
            .setPalette(s -> s.primaryPalette)
            .setTone(
                s -> {
                  if (!s.isDark && s.sourceColorHct.getChroma() <= 12) {
                    return 90.0;
                  }
                  return s.sourceColorHct.getTone() > 55
                      ? MathUtils.clampDouble(61, 90, s.sourceColorHct.getTone())
                      : MathUtils.clampDouble(30, 49, s.sourceColorHct.getTone());
                })
            .setIsBackground(true)
            .setBackground(s -> highestSurface(s))
            .setContrastCurve(s -> s.contrastLevel > 0 ? getContrastCurve(1.5) : null)
            .build();
    return super.primaryContainer().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onPrimaryContainer() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("on_primary_container")
            .setPalette(s -> s.primaryPalette)
            .setBackground(s -> primaryContainer())
            .setContrastCurve(s -> getContrastCurve(6))
            .build();
    return super.onPrimaryContainer().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor primaryFixed() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("primary_fixed")
            .setPalette(s -> s.primaryPalette)
            .setTone(
                s -> {
                  DynamicScheme tempS =
                      DynamicScheme.from(s, /* isDark= */ false, /* contrastLevel= */ 0.0);
                  return primaryContainer().getTone(tempS);
                })
            .setIsBackground(true)
            .setBackground(s -> highestSurface(s))
            .setContrastCurve(s -> s.contrastLevel > 0 ? getContrastCurve(1.5) : null)
            .build();
    return super.primaryFixed().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor primaryFixedDim() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("primary_fixed_dim")
            .setPalette(s -> s.primaryPalette)
            .setTone(s -> primaryFixed().getTone(s))
            .setIsBackground(true)
            .setBackground(s -> highestSurface(s))
            .setToneDeltaPair(
                s -> new ToneDeltaPair(primaryFixedDim(), primaryFixed(), 5, DARKER, EXACT))
            .setContrastCurve(s -> s.contrastLevel > 0 ? getContrastCurve(1.5) : null)
            .build();
    return super.primaryFixedDim().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onPrimaryFixed() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("on_primary_fixed")
            .setPalette(s -> s.primaryPalette)
            .setBackground(s -> primaryFixed().getTone(s) > 57 ? primaryFixedDim() : primaryFixed())
            .setContrastCurve(s -> getContrastCurve(7))
            .build();
    return super.onPrimaryFixed().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onPrimaryFixedVariant() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("on_primary_fixed_variant")
            .setPalette(s -> s.primaryPalette)
            .setBackground(s -> primaryFixed().getTone(s) > 57 ? primaryFixedDim() : primaryFixed())
            .setContrastCurve(s -> getContrastCurve(4.5))
            .build();
    return super.onPrimaryFixedVariant().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor secondary() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("secondary")
            .setPalette(s -> s.secondaryPalette)
            .setTone(s -> s.isDark ? tMinC(s.secondaryPalette) : tMaxC(s.secondaryPalette))
            .setIsBackground(true)
            .setBackground(s -> highestSurface(s))
            .setContrastCurve(s -> getContrastCurve(4.5))
            .setToneDeltaPair(
                s ->
                    s.platform == DynamicScheme.Platform.PHONE
                        ? new ToneDeltaPair(
                            secondaryContainer(), secondary(), 5, RELATIVE_LIGHTER, FARTHER)
                        : null)
            .build();
    return super.secondary().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor secondaryDim() {
    // Remapped to secondary in 2025 spec.
    DynamicColor color2026 = secondary().toBuilder().setName("secondary_dim").build();
    return super.secondaryDim().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onSecondary() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("on_secondary")
            .setPalette(s -> s.secondaryPalette)
            .setBackground(s -> secondary())
            .setContrastCurve(s -> getContrastCurve(6))
            .build();
    return super.onSecondary().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor secondaryContainer() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("secondary_container")
            .setPalette(s -> s.secondaryPalette)
            .setTone(
                s ->
                    s.isDark
                        ? tMinC(s.secondaryPalette, 20, 49)
                        : tMaxC(s.secondaryPalette, 61, 90))
            .setIsBackground(true)
            .setBackground(s -> highestSurface(s))
            .setContrastCurve(s -> s.contrastLevel > 0 ? getContrastCurve(1.5) : null)
            .build();
    return super.secondaryContainer().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onSecondaryContainer() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("on_secondary_container")
            .setPalette(s -> s.secondaryPalette)
            .setBackground(s -> secondaryContainer())
            .setContrastCurve(s -> getContrastCurve(6))
            .build();
    return super.onSecondaryContainer().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor secondaryFixed() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("secondary_fixed")
            .setPalette(s -> s.secondaryPalette)
            .setTone(
                s -> {
                  DynamicScheme tempS =
                      DynamicScheme.from(s, /* isDark= */ false, /* contrastLevel= */ 0.0);
                  return secondaryContainer().getTone(tempS);
                })
            .setIsBackground(true)
            .setBackground(s -> highestSurface(s))
            .setContrastCurve(s -> s.contrastLevel > 0 ? getContrastCurve(1.5) : null)
            .build();
    return super.secondaryFixed().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor secondaryFixedDim() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("secondary_fixed_dim")
            .setPalette(s -> s.secondaryPalette)
            .setTone(s -> secondaryFixed().getTone(s))
            .setIsBackground(true)
            .setBackground(s -> highestSurface(s))
            .setToneDeltaPair(
                s -> new ToneDeltaPair(secondaryFixedDim(), secondaryFixed(), 5, DARKER, EXACT))
            .setContrastCurve(s -> s.contrastLevel > 0 ? getContrastCurve(1.5) : null)
            .build();
    return super.secondaryFixedDim().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onSecondaryFixed() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("on_secondary_fixed")
            .setPalette(s -> s.secondaryPalette)
            .setBackground(
                s -> secondaryFixed().getTone(s) > 57 ? secondaryFixedDim() : secondaryFixed())
            .setContrastCurve(s -> getContrastCurve(7))
            .build();
    return super.onSecondaryFixed().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onSecondaryFixedVariant() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("on_secondary_fixed_variant")
            .setPalette(s -> s.secondaryPalette)
            .setBackground(
                s -> secondaryFixed().getTone(s) > 57 ? secondaryFixedDim() : secondaryFixed())
            .setContrastCurve(s -> getContrastCurve(4.5))
            .build();
    return super.onSecondaryFixedVariant().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor tertiary() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("tertiary")
            .setPalette(s -> s.tertiaryPalette)
            .setTone(
                s ->
                    s.sourceColorHctList.size() > 1
                        ? s.sourceColorHctList.get(1).getTone()
                        : s.sourceColorHct.getTone())
            .setIsBackground(true)
            .setBackground(s -> highestSurface(s))
            .setContrastCurve(s -> getContrastCurve(4.5))
            .setToneDeltaPair(
                s ->
                    s.platform == DynamicScheme.Platform.PHONE
                        ? new ToneDeltaPair(
                            tertiaryContainer(), tertiary(), 5, RELATIVE_LIGHTER, FARTHER)
                        : null)
            .build();
    return super.tertiary().toBuilder().extendSpecVersion(SpecVersion.SPEC_2026, color2026).build();
  }

  @Override
  public DynamicColor tertiaryDim() {
    // Remapped to tertiary in 2025 spec.
    DynamicColor color2026 = tertiary().toBuilder().setName("tertiary_dim").build();
    return super.tertiaryDim().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onTertiary() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("on_tertiary")
            .setPalette(s -> s.tertiaryPalette)
            .setBackground(s -> tertiary())
            .setContrastCurve(s -> getContrastCurve(6))
            .build();
    return super.onTertiary().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor tertiaryContainer() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("tertiary_container")
            .setPalette(s -> s.tertiaryPalette)
            .setTone(
                s -> {
                  Hct secondarySourceColorHct =
                      s.sourceColorHctList.size() > 1
                          ? s.sourceColorHctList.get(1)
                          : s.sourceColorHct;
                  return secondarySourceColorHct.getTone() > 55
                      ? MathUtils.clampDouble(61, 90, secondarySourceColorHct.getTone())
                      : MathUtils.clampDouble(20, 49, secondarySourceColorHct.getTone());
                })
            .setIsBackground(true)
            .setBackground(s -> highestSurface(s))
            .setContrastCurve(s -> s.contrastLevel > 0 ? getContrastCurve(1.5) : null)
            .build();
    return super.tertiaryContainer().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onTertiaryContainer() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("on_tertiary_container")
            .setPalette(s -> s.tertiaryPalette)
            .setBackground(s -> tertiaryContainer())
            .setContrastCurve(s -> getContrastCurve(6))
            .build();
    return super.onTertiaryContainer().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor tertiaryFixed() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("tertiary_fixed")
            .setPalette(s -> s.tertiaryPalette)
            .setTone(
                s -> {
                  DynamicScheme tempS =
                      DynamicScheme.from(s, /* isDark= */ false, /* contrastLevel= */ 0.0);
                  return tertiaryContainer().getTone(tempS);
                })
            .setIsBackground(true)
            .setBackground(s -> highestSurface(s))
            .setContrastCurve(s -> s.contrastLevel > 0 ? getContrastCurve(1.5) : null)
            .build();
    return super.tertiaryFixed().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor tertiaryFixedDim() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("tertiary_fixed_dim")
            .setPalette(s -> s.tertiaryPalette)
            .setTone(s -> tertiaryFixed().getTone(s))
            .setIsBackground(true)
            .setBackground(s -> highestSurface(s))
            .setToneDeltaPair(
                s -> new ToneDeltaPair(tertiaryFixedDim(), tertiaryFixed(), 5, DARKER, EXACT))
            .setContrastCurve(s -> s.contrastLevel > 0 ? getContrastCurve(1.5) : null)
            .build();
    return super.tertiaryFixedDim().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onTertiaryFixed() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("on_tertiary_fixed")
            .setPalette(s -> s.tertiaryPalette)
            .setBackground(
                s -> tertiaryFixed().getTone(s) > 57 ? tertiaryFixedDim() : tertiaryFixed())
            .setContrastCurve(s -> getContrastCurve(7))
            .build();
    return super.onTertiaryFixed().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onTertiaryFixedVariant() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("on_tertiary_fixed_variant")
            .setPalette(s -> s.tertiaryPalette)
            .setBackground(
                s -> tertiaryFixed().getTone(s) > 57 ? tertiaryFixedDim() : tertiaryFixed())
            .setContrastCurve(s -> getContrastCurve(4.5))
            .build();
    return super.onTertiaryFixedVariant().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor error() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("error")
            .setPalette(s -> s.errorPalette)
            .setTone(s -> tMaxC(s.errorPalette))
            .setIsBackground(true)
            .setBackground(s -> highestSurface(s))
            .setContrastCurve(s -> getContrastCurve(4.5))
            .setToneDeltaPair(
                s ->
                    s.platform == DynamicScheme.Platform.PHONE
                        ? new ToneDeltaPair(errorContainer(), error(), 5, RELATIVE_LIGHTER, FARTHER)
                        : null)
            .build();
    return super.error().toBuilder().extendSpecVersion(SpecVersion.SPEC_2026, color2026).build();
  }

  @NonNull
  @Override
  public DynamicColor errorDim() {
    // Remapped to error in 2026 spec.
    DynamicColor color2026 = error().toBuilder().setName("error_dim").build();
    return super.errorDim().toBuilder().extendSpecVersion(SpecVersion.SPEC_2026, color2026).build();
  }

  @NonNull
  @Override
  public DynamicColor onError() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("on_error")
            .setPalette(s -> s.errorPalette)
            .setBackground(s -> error())
            .setContrastCurve(s -> getContrastCurve(6))
            .build();
    return super.onError().toBuilder().extendSpecVersion(SpecVersion.SPEC_2026, color2026).build();
  }

  @NonNull
  @Override
  public DynamicColor errorContainer() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("error_container")
            .setPalette(s -> s.errorPalette)
            .setTone(s -> s.isDark ? tMinC(s.errorPalette) : tMaxC(s.errorPalette))
            .setIsBackground(true)
            .setBackground(s -> highestSurface(s))
            .setContrastCurve(s -> s.contrastLevel > 0 ? getContrastCurve(1.5) : null)
            .build();
    return super.errorContainer().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }

  @NonNull
  @Override
  public DynamicColor onErrorContainer() {
    DynamicColor color2026 =
        new DynamicColor.Builder()
            .setName("on_error_container")
            .setPalette(s -> s.errorPalette)
            .setBackground(s -> errorContainer())
            .setContrastCurve(s -> getContrastCurve(6))
            .build();
    return super.onErrorContainer().toBuilder()
        .extendSpecVersion(SpecVersion.SPEC_2026, color2026)
        .build();
  }
}
