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

package dynamiccolor;

import dislike.DislikeAnalyzer;
import hct.Hct;
import hct.ViewingConditions;
import scheme.DynamicScheme;
import scheme.Variant;

/** Named colors, otherwise known as tokens, or roles, in the Material Design system. */
// Prevent lint for Function.apply not being available on Android before API level 14 (4.0.1).
// "AndroidJdkLibsChecker" for Function, "NewApi" for Function.apply().
// A java_library Bazel rule with an Android constraint cannot skip these warnings without this
// annotation; another solution would be to create an android_library rule and supply
// AndroidManifest with an SDK set higher than 14.
@SuppressWarnings({"AndroidJdkLibsChecker", "NewApi"})
public final class MaterialDynamicColors {
  private static final double CONTAINER_ACCENT_TONE_DELTA = 15.0;

  public MaterialDynamicColors() {}

  public DynamicColor highestSurface(DynamicScheme s) {
    return s.isDark ? surfaceBright() : surfaceDim();
  }

  public DynamicColor background() {
    return DynamicColor.fromPalette((s) -> s.neutralPalette, (s) -> s.isDark ? 6.0 : 98.0);
  }

  public DynamicColor onBackground() {
    return DynamicColor.fromPalette(
        (s) -> s.neutralPalette, (s) -> s.isDark ? 90.0 : 10.0, (s) -> background());
  }

  public DynamicColor surface() {
    return DynamicColor.fromPalette((s) -> s.neutralPalette, (s) -> s.isDark ? 6.0 : 98.0);
  }

  public DynamicColor surfaceInverse() {
    return DynamicColor.fromPalette((s) -> s.neutralPalette, (s) -> s.isDark ? 90.0 : 30.0);
  }

  public DynamicColor surfaceBright() {
    return DynamicColor.fromPalette((s) -> s.neutralPalette, (s) -> s.isDark ? 24.0 : 98.0);
  }

  public DynamicColor surfaceDim() {
    return DynamicColor.fromPalette((s) -> s.neutralPalette, (s) -> s.isDark ? 6.0 : 87.0);
  }

  public DynamicColor surfaceSub2() {
    return DynamicColor.fromPalette((s) -> s.neutralPalette, (s) -> s.isDark ? 4.0 : 100.0);
  }

  public DynamicColor surfaceSub1() {
    return DynamicColor.fromPalette((s) -> s.neutralPalette, (s) -> s.isDark ? 10.0 : 96.0);
  }

  public DynamicColor surfaceContainer() {
    return DynamicColor.fromPalette((s) -> s.neutralPalette, (s) -> s.isDark ? 12.0 : 94.0);
  }

  public DynamicColor surfaceAdd1() {
    return DynamicColor.fromPalette((s) -> s.neutralPalette, (s) -> s.isDark ? 17.0 : 92.0);
  }

  public DynamicColor surfaceAdd2() {
    return DynamicColor.fromPalette((s) -> s.neutralPalette, (s) -> s.isDark ? 22.0 : 90.0);
  }

  public DynamicColor onSurface() {
    return DynamicColor.fromPalette(
        (s) -> s.neutralPalette, (s) -> s.isDark ? 90.0 : 10.0, this::highestSurface);
  }

  public DynamicColor onSurfaceInverse() {
    return DynamicColor.fromPalette(
        (s) -> s.neutralPalette, (s) -> s.isDark ? 20.0 : 95.0, (s) -> surfaceInverse());
  }

  public DynamicColor surfaceVariant() {
    return DynamicColor.fromPalette((s) -> s.neutralVariantPalette, (s) -> s.isDark ? 30.0 : 90.0);
  }

  public DynamicColor onSurfaceVariant() {
    return DynamicColor.fromPalette(
        (s) -> s.neutralVariantPalette, (s) -> s.isDark ? 80.0 : 30.0, (s) -> surfaceVariant());
  }

  public DynamicColor outline() {
    return DynamicColor.fromPalette(
        (s) -> s.neutralVariantPalette, (s) -> 50.0, this::highestSurface);
  }

  public DynamicColor outlineVariant() {
    return DynamicColor.fromPalette(
        (s) -> s.neutralVariantPalette, (s) -> s.isDark ? 30.0 : 80.0, this::highestSurface);
  }

  public DynamicColor primaryContainer() {
    return DynamicColor.fromPalette(
        (s) -> s.primaryPalette,
        (s) -> {
          if (!isFidelity(s)) {
            return s.isDark ? 30.0 : 90.0;
          }
          return performAlbers(s.sourceColorHct, s);
        },
        this::highestSurface);
  }

  public DynamicColor onPrimaryContainer() {
    return DynamicColor.fromPalette(
        (s) -> s.primaryPalette,
        (s) -> {
          if (!isFidelity(s)) {
            return s.isDark ? 90.0 : 10.0;
          }
          return DynamicColor.contrastingTone(primaryContainer().tone.apply(s), 4.5);
        },
        (s) -> primaryContainer(),
        null);
  }

  public DynamicColor primary() {
    return DynamicColor.fromPalette(
        (s) -> s.primaryPalette,
        (s) -> s.isDark ? 80.0 : 40.0,
        this::highestSurface,
        (s) ->
            new ToneDeltaConstraint(
                CONTAINER_ACCENT_TONE_DELTA,
                primaryContainer(),
                s.isDark ? TonePolarity.DARKER : TonePolarity.LIGHTER));
  }

  public DynamicColor primaryInverse() {
    return DynamicColor.fromPalette(
        (s) -> s.primaryPalette, (s) -> s.isDark ? 40.0 : 80.0, (s) -> surfaceInverse());
  }

  public DynamicColor onPrimary() {
    return DynamicColor.fromPalette(
        (s) -> s.primaryPalette, (s) -> s.isDark ? 20.0 : 100.0, (s) -> primary());
  }

  public DynamicColor secondaryContainer() {
    return DynamicColor.fromPalette(
        (s) -> s.secondaryPalette,
        (s) -> {
          final double initialTone = s.isDark ? 30.0 : 90.0;
          if (!isFidelity(s)) {
            return initialTone;
          }
          double answer =
              findDesiredChromaByTone(
                  s.secondaryPalette.getHue(),
                  s.secondaryPalette.getChroma(),
                  initialTone,
                  !s.isDark);
          answer = performAlbers(s.secondaryPalette.getHct(answer), s);
          return answer;
        },
        this::highestSurface);
  }

  public DynamicColor onSecondaryContainer() {
    return DynamicColor.fromPalette(
        (s) -> s.secondaryPalette,
        (s) -> {
          if (!isFidelity(s)) {
            return s.isDark ? 90.0 : 10.0;
          }
          return DynamicColor.contrastingTone(secondaryContainer().tone.apply(s), 4.5);
        },
        (s) -> secondaryContainer());
  }

  public DynamicColor secondary() {
    return DynamicColor.fromPalette(
        (s) -> s.secondaryPalette,
        (s) -> s.isDark ? 80.0 : 40.0,
        this::highestSurface,
        (s) ->
            new ToneDeltaConstraint(
                CONTAINER_ACCENT_TONE_DELTA,
                secondaryContainer(),
                s.isDark ? TonePolarity.DARKER : TonePolarity.LIGHTER));
  }

  public DynamicColor onSecondary() {
    return DynamicColor.fromPalette(
        (s) -> s.secondaryPalette, (s) -> s.isDark ? 20.0 : 100.0, (s) -> secondary());
  }

  public DynamicColor tertiaryContainer() {
    return DynamicColor.fromPalette(
        (s) -> s.tertiaryPalette,
        (s) -> {
          if (!isFidelity(s)) {
            return s.isDark ? 30.0 : 90.0;
          }
          final double albersTone =
              performAlbers(s.tertiaryPalette.getHct(s.sourceColorHct.getTone()), s);
          final Hct proposedHct = s.tertiaryPalette.getHct(albersTone);
          return DislikeAnalyzer.fixIfDisliked(proposedHct).getTone();
        },
        this::highestSurface);
  }

  public DynamicColor onTertiaryContainer() {
    return DynamicColor.fromPalette(
        (s) -> s.tertiaryPalette,
        (s) -> {
          if (!isFidelity(s)) {
            return s.isDark ? 90.0 : 10.0;
          }
          return DynamicColor.contrastingTone(tertiaryContainer().tone.apply(s), 4.5);
        },
        (s) -> tertiaryContainer());
  }

  public DynamicColor tertiary() {
    return DynamicColor.fromPalette(
        (s) -> s.tertiaryPalette,
        (s) -> s.isDark ? 80.0 : 40.0,
        this::highestSurface,
        (s) ->
            new ToneDeltaConstraint(
                CONTAINER_ACCENT_TONE_DELTA,
                tertiaryContainer(),
                s.isDark ? TonePolarity.DARKER : TonePolarity.LIGHTER));
  }

  public DynamicColor onTertiary() {
    return DynamicColor.fromPalette(
        (s) -> s.tertiaryPalette, (s) -> s.isDark ? 20.0 : 100.0, (s) -> tertiary());
  }

  public DynamicColor errorContainer() {
    return DynamicColor.fromPalette(
        (s) -> s.errorPalette, (s) -> s.isDark ? 30.0 : 90.0, this::highestSurface);
  }

  public DynamicColor onErrorContainer() {
    return DynamicColor.fromPalette(
        (s) -> s.errorPalette, (s) -> s.isDark ? 90.0 : 10.0, (s) -> errorContainer());
  }

  public DynamicColor error() {
    return DynamicColor.fromPalette(
        (s) -> s.errorPalette,
        (s) -> s.isDark ? 80.0 : 40.0,
        this::highestSurface,
        (s) ->
            new ToneDeltaConstraint(
                CONTAINER_ACCENT_TONE_DELTA,
                errorContainer(),
                s.isDark ? TonePolarity.DARKER : TonePolarity.LIGHTER));
  }

  public DynamicColor onError() {
    return DynamicColor.fromPalette(
        (s) -> s.errorPalette, (s) -> s.isDark ? 20.0 : 100.0, (s) -> error());
  }

  /**
   * These colors were present in Android framework before Android U, and used by MDC controls. They
   * should be avoided, if possible. It's unclear if they're used on multiple backgrounds, and if
   * they are, they can't be adjusted for contrast.* For now, they will be set with no background,
   * and those won't adjust for contrast, avoiding issues.
   *
   * <p>* For example, if the same color is on a white background _and_ black background, there's no
   * way to increase contrast with either without losing contrast with the other.
   */
  // colorControlActivated documented as colorAccent in M3 & GM3.
  // colorAccent documented as colorSecondary in M3 and colorPrimary in GM3.
  // Android used Material's Container as Primary/Secondary/Tertiary at launch.
  // Therefore, this is a duplicated version of Primary Container.
  public static final DynamicColor controlActivated =
      DynamicColor.fromPalette((s) -> s.primaryPalette, (s) -> s.isDark ? 30.0 : 90.0, null);

  // colorControlNormal documented as textColorSecondary in M3 & GM3.
  // In Material, textColorSecondary points to onSurfaceVariant in the non-disabled state,
  // which is Neutral Variant T30/80 in light/dark.
  public DynamicColor controlNormal() {
    return DynamicColor.fromPalette((s) -> s.neutralVariantPalette, (s) -> s.isDark ? 80.0 : 30.0);
  }

  // colorControlHighlight documented, in both M3 & GM3:
  // Light mode: #1f000000 dark mode: #33ffffff.
  // These are black and white with some alpha.
  // 1F hex = 31 decimal; 31 / 255 = 12% alpha.
  // 33 hex = 51 decimal; 51 / 255 = 20% alpha.
  // DynamicColors do not support alpha currently, and _may_ not need it for this use case,
  // depending on how MDC resolved alpha for the other cases.
  // Returning black in dark mode, white in light mode.
  public DynamicColor controlHighlight() {
    return new DynamicColor(
        s -> 0.0,
        s -> 0.0,
        s -> s.isDark ? 100.0 : 0.0,
        s -> s.isDark ? 0.20 : 0.12,
        null,
        scheme ->
            DynamicColor.toneMinContrastDefault((s) -> s.isDark ? 100.0 : 0.0, null, scheme, null),
        scheme ->
            DynamicColor.toneMaxContrastDefault((s) -> s.isDark ? 100.0 : 0.0, null, scheme, null),
        null);
  }

  // textColorPrimaryInverse documented, in both M3 & GM3, documented as N10/N90.
  public DynamicColor textPrimaryInverse() {
    return DynamicColor.fromPalette((s) -> s.neutralPalette, (s) -> s.isDark ? 10.0 : 90.0);
  }

  // textColorSecondaryInverse and textColorTertiaryInverse both documented, in both M3 & GM3, as
  // NV30/NV80
  public DynamicColor textSecondaryAndTertiaryInverse() {
    return DynamicColor.fromPalette((s) -> s.neutralVariantPalette, (s) -> s.isDark ? 30.0 : 80.0);
  }

  // textColorPrimaryInverseDisableOnly documented, in both M3 & GM3, as N10/N90
  public DynamicColor textPrimaryInverseDisableOnly() {
    return DynamicColor.fromPalette((s) -> s.neutralPalette, (s) -> s.isDark ? 10.0 : 90.0);
  }

  // textColorSecondaryInverse and textColorTertiaryInverse in disabled state both documented,
  // in both M3 & GM3, as N10/N90
  public DynamicColor textSecondaryAndTertiaryInverseDisabled() {
    return DynamicColor.fromPalette((s) -> s.neutralPalette, (s) -> s.isDark ? 10.0 : 90.0);
  }

  // textColorHintInverse documented, in both M3 & GM3, as N10/N90
  public DynamicColor textHintInverse() {
    return DynamicColor.fromPalette((s) -> s.neutralPalette, (s) -> s.isDark ? 10.0 : 90.0);
  }

  private static ViewingConditions viewingConditionsForAlbers(DynamicScheme scheme) {
    return ViewingConditions.defaultWithBackgroundLstar(scheme.isDark ? 30.0 : 80.0);
  }

  private static boolean isFidelity(DynamicScheme scheme) {
    return scheme.variant == Variant.FIDELITY || scheme.variant == Variant.CONTENT;
  }

  static double findDesiredChromaByTone(
      double hue, double chroma, double tone, boolean byDecreasingTone) {
    double answer = tone;

    Hct closestToChroma = Hct.from(hue, chroma, tone);
    if (closestToChroma.getChroma() < chroma) {
      double chromaPeak = closestToChroma.getChroma();
      while (closestToChroma.getChroma() < chroma) {
        answer += byDecreasingTone ? -1.0 : 1.0;
        Hct potentialSolution = Hct.from(hue, chroma, answer);
        if (chromaPeak > potentialSolution.getChroma()) {
          break;
        }
        if (Math.abs(potentialSolution.getChroma() - chroma) < 0.4) {
          break;
        }

        double potentialDelta = Math.abs(potentialSolution.getChroma() - chroma);
        double currentDelta = Math.abs(closestToChroma.getChroma() - chroma);
        if (potentialDelta < currentDelta) {
          closestToChroma = potentialSolution;
        }
        chromaPeak = Math.max(chromaPeak, potentialSolution.getChroma());
      }
    }

    return answer;
  }

  static double performAlbers(Hct prealbers, DynamicScheme scheme) {
    final Hct albersd = prealbers.inViewingConditions(viewingConditionsForAlbers(scheme));
    if (DynamicColor.tonePrefersLightForeground(prealbers.getTone())
        && !DynamicColor.toneAllowsLightForeground(albersd.getTone())) {
      return DynamicColor.enableLightForeground(prealbers.getTone());
    } else {
      return DynamicColor.enableLightForeground(albersd.getTone());
    }
  }
}
