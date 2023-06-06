// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

private func _isFidelity(_ scheme: DynamicScheme) -> Bool {
  return scheme.variant == Variant.fidelity || scheme.variant == Variant.content
}

private func _isMonochrome(_ scheme: DynamicScheme) -> Bool {
  return scheme.variant == Variant.monochrome
}

/// Tokens, or named colors, in the Material Design system.
class MaterialDynamicColors {
  static let contentAccentToneDelta: Double = 15

  static func highestSurface(_ s: DynamicScheme) -> DynamicColor {
    return s.isDark ? surfaceBright : surfaceDim
  }

  static func viewingConditionsForAlbers(_ scheme: DynamicScheme) -> ViewingConditions {
    return ViewingConditions.make(backgroundLstar: scheme.isDark ? 30 : 80)
  }

  static let primaryPaletteKeyColor: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.primaryPalette
    },
    tone: { scheme in
      return scheme.primaryPalette.keyColor.tone
    }
  )

  static let secondaryPaletteKeyColor: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.secondaryPalette
    },
    tone: { scheme in
      return scheme.secondaryPalette.keyColor.tone
    }
  )

  static let tertiaryPaletteKeyColor: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.tertiaryPalette
    },
    tone: { scheme in
      return scheme.tertiaryPalette.keyColor.tone
    }
  )

  static let neutralPaletteKeyColor: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.neutralPalette
    },
    tone: { scheme in
      return scheme.neutralPalette.keyColor.tone
    }
  )

  static let neutralVariantPaletteKeyColor: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.neutralVariantPalette
    },
    tone: { scheme in
      return scheme.neutralVariantPalette.keyColor.tone
    }
  )

  static let background: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.neutralPalette
    },
    tone: { scheme in
      return scheme.isDark ? 6 : 98
    }
  )

  static let onBackground: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.neutralPalette
    },
    tone: { scheme in
      return scheme.isDark ? 90 : 10
    },
    background: { scheme in
      return background
    }
  )

  static let surface: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.neutralPalette
    },
    tone: { scheme in
      return scheme.isDark ? 6 : 98
    }
  )

  static let surfaceDim: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.neutralPalette
    },
    tone: { scheme in
      return scheme.isDark ? 6 : 87
    }
  )

  static let surfaceBright: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.neutralPalette
    },
    tone: { scheme in
      return scheme.isDark ? 24 : 98
    }
  )

  static let surfaceContainerLowest: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.neutralPalette
    },
    tone: { scheme in
      return scheme.isDark ? 4 : 100
    }
  )

  static let surfaceContainerLow: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.neutralPalette
    },
    tone: { scheme in
      return scheme.isDark ? 10 : 96
    }
  )

  static let surfaceContainer: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.neutralPalette
    },
    tone: { scheme in
      return scheme.isDark ? 12 : 94
    }
  )

  static let surfaceContainerHigh: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.neutralPalette
    },
    tone: { scheme in
      return scheme.isDark ? 17 : 92
    }
  )

  static let surfaceContainerHighest: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.neutralPalette
    },
    tone: { scheme in
      return scheme.isDark ? 22 : 90
    }
  )

  static let onSurface: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.neutralPalette
    },
    tone: { scheme in
      return scheme.isDark ? 90 : 10
    },
    background: { scheme in
      return highestSurface(scheme)
    }
  )

  static let surfaceVariant: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.neutralVariantPalette
    },
    tone: { scheme in
      return scheme.isDark ? 30 : 90
    }
  )

  static let onSurfaceVariant: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.neutralVariantPalette
    },
    tone: { scheme in
      return scheme.isDark ? 80 : 30
    },
    background: { scheme in
      return surfaceVariant
    }
  )

  static let inverseSurface: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.neutralPalette
    },
    tone: { scheme in
      return scheme.isDark ? 90 : 20
    }
  )

  static let inverseOnSurface: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.neutralPalette
    },
    tone: { scheme in
      return scheme.isDark ? 20 : 95
    },
    background: { scheme in
      return inverseSurface
    }
  )

  static let outline: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.neutralVariantPalette
    },
    tone: { scheme in
      return scheme.isDark ? 60 : 50
    },
    background: { scheme in
      return highestSurface(scheme)
    }
  )

  static let outlineVariant: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.neutralVariantPalette
    },
    tone: { scheme in
      return scheme.isDark ? 30 : 80
    },
    background: { scheme in
      return highestSurface(scheme)
    }
  )

  static let shadow: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.neutralPalette
    },
    tone: { scheme in
      return 0
    }
  )

  static let scrim: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.neutralPalette
    },
    tone: { scheme in
      return 0
    }
  )

  static let surfaceTint: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.primaryPalette
    },
    tone: { scheme in
      return scheme.isDark ? 80 : 40
    }
  )

  static let primary: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.primaryPalette
    },
    tone: { scheme in
      if _isMonochrome(scheme) {
        return scheme.isDark ? 100 : 0
      }
      return scheme.isDark ? 80 : 40
    },
    background: { scheme in
      return highestSurface(scheme)
    },
    toneDeltaConstraint: { scheme in
      return ToneDeltaConstraint(
        delta: contentAccentToneDelta,
        keepAway: primaryContainer,
        keepAwayPolarity: scheme.isDark ? TonePolarity.darker : TonePolarity.lighter
      )
    }
  )

  static let onPrimary: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.primaryPalette
    },
    tone: { scheme in
      if _isMonochrome(scheme) {
        return scheme.isDark ? 10 : 90
      }
      return scheme.isDark ? 20 : 100
    },
    background: { scheme in
      return primary
    }
  )

  static let primaryContainer: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.primaryPalette
    },
    tone: { scheme in
      if _isFidelity(scheme) {
        return _performAlbers(scheme.sourceColorHct, scheme)
      }
      if _isMonochrome(scheme) {
        return scheme.isDark ? 85 : 25
      }
      return scheme.isDark ? 30 : 90
    },
    background: { scheme in
      return highestSurface(scheme)
    }
  )

  static let onPrimaryContainer: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.primaryPalette
    },
    tone: { scheme in
      if _isFidelity(scheme) {
        return DynamicColor.foregroundTone(primaryContainer.tone(scheme), 4.5)
      }
      if _isMonochrome(scheme) {
        return scheme.isDark ? 0 : 100
      }
      return scheme.isDark ? 90 : 10
    },
    background: { scheme in
      return primaryContainer
    }
  )

  static let inversePrimary: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.primaryPalette
    },
    tone: { scheme in
      return scheme.isDark ? 40 : 80
    },
    background: { scheme in
      return inverseSurface
    }
  )

  static let secondary: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.secondaryPalette
    },
    tone: { scheme in
      return scheme.isDark ? 80 : 40
    },
    background: { scheme in
      return highestSurface(scheme)
    },
    toneDeltaConstraint: { scheme in
      return ToneDeltaConstraint(
        delta: contentAccentToneDelta,
        keepAway: secondaryContainer,
        keepAwayPolarity: scheme.isDark ? TonePolarity.darker : TonePolarity.lighter
      )
    }
  )

  static let onSecondary: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.secondaryPalette
    },
    tone: { scheme in
      if _isMonochrome(scheme) {
        return scheme.isDark ? 10 : 100
      }
      return scheme.isDark ? 20 : 100
    },
    background: { scheme in
      return secondary
    }
  )

  static let secondaryContainer: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.secondaryPalette
    },
    tone: { scheme in
      if _isMonochrome(scheme) {
        return scheme.isDark ? 30 : 85
      }
      let initialTone: Double = scheme.isDark ? 30 : 90
      if !_isFidelity(scheme) {
        return initialTone
      }
      var answer = _findDesiredChromaByTone(
        scheme.secondaryPalette.hue, scheme.secondaryPalette.chroma, initialTone,
        scheme.isDark ? false : true)
      answer = _performAlbers(scheme.secondaryPalette.getHct(answer), scheme)
      return answer
    },
    background: { scheme in
      return highestSurface(scheme)
    }
  )

  static let onSecondaryContainer: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.secondaryPalette
    },
    tone: { scheme in
      if !_isFidelity(scheme) {
        return scheme.isDark ? 90 : 10
      }
      return DynamicColor.foregroundTone(secondaryContainer.tone(scheme), 4.5)
    },
    background: { scheme in
      return secondaryContainer
    }
  )

  static let tertiary: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.tertiaryPalette
    },
    tone: { scheme in
      if _isMonochrome(scheme) {
        return scheme.isDark ? 90 : 25
      }
      return scheme.isDark ? 80 : 40
    },
    background: { scheme in
      return highestSurface(scheme)
    },
    toneDeltaConstraint: { scheme in
      return ToneDeltaConstraint(
        delta: contentAccentToneDelta,
        keepAway: tertiaryContainer,
        keepAwayPolarity: scheme.isDark ? TonePolarity.darker : TonePolarity.lighter
      )
    }
  )

  static let onTertiary: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.tertiaryPalette
    },
    tone: { scheme in
      if _isMonochrome(scheme) {
        return scheme.isDark ? 10 : 90
      }
      return scheme.isDark ? 20 : 100
    },
    background: { scheme in
      return tertiary
    }
  )

  static let tertiaryContainer: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.tertiaryPalette
    },
    tone: { scheme in
      if _isMonochrome(scheme) {
        return scheme.isDark ? 60 : 49
      }
      if !_isFidelity(scheme) {
        return scheme.isDark ? 30 : 90
      }

      let albersTone = _performAlbers(
        scheme.tertiaryPalette.getHct(scheme.sourceColorHct.tone), scheme)
      let proposedHct = scheme.tertiaryPalette.getHct(albersTone)
      return DislikeAnalyzer.fixIfDisliked(proposedHct).tone
    },
    background: { scheme in
      return highestSurface(scheme)
    }
  )

  static let onTertiaryContainer: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.tertiaryPalette
    },
    tone: { scheme in
      if _isMonochrome(scheme) {
        return scheme.isDark ? 0 : 100
      }
      if !_isFidelity(scheme) {
        return scheme.isDark ? 90 : 10
      }
      return DynamicColor.foregroundTone(tertiaryContainer.tone(scheme), 4.5)
    },
    background: { scheme in
      return tertiaryContainer
    }
  )

  static let error: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.errorPalette
    },
    tone: { scheme in
      return scheme.isDark ? 80 : 40
    },
    background: { scheme in
      return highestSurface(scheme)
    },
    toneDeltaConstraint: { scheme in
      return ToneDeltaConstraint(
        delta: contentAccentToneDelta,
        keepAway: errorContainer,
        keepAwayPolarity: scheme.isDark ? TonePolarity.darker : TonePolarity.lighter
      )
    }
  )

  static let onError: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.errorPalette
    },
    tone: { scheme in
      return scheme.isDark ? 20 : 100
    },
    background: { scheme in
      return error
    }
  )

  static let errorContainer: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.errorPalette
    },
    tone: { scheme in
      return scheme.isDark ? 30 : 90
    },
    background: { scheme in
      return highestSurface(scheme)
    }
  )

  static let onErrorContainer: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.errorPalette
    },
    tone: { scheme in
      return scheme.isDark ? 90 : 10
    },
    background: { scheme in
      return errorContainer
    }
  )

  static let primaryFixed: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.primaryPalette
    },
    tone: { scheme in
      if _isMonochrome(scheme) {
        return scheme.isDark ? 100 : 10
      }
      return 90
    },
    background: { scheme in
      return highestSurface(scheme)
    }
  )

  static let primaryFixedDim: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.primaryPalette
    },
    tone: { scheme in
      if _isMonochrome(scheme) {
        return scheme.isDark ? 90 : 20
      }
      return 80
    },
    background: { scheme in
      return highestSurface(scheme)
    }
  )

  static let onPrimaryFixed: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.primaryPalette
    },
    tone: { scheme in
      if _isMonochrome(scheme) {
        return scheme.isDark ? 10 : 90
      }
      return 10
    },
    background: { scheme in
      return primaryFixedDim
    }
  )

  static let onPrimaryFixedVariant: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.primaryPalette
    },
    tone: { scheme in
      if _isMonochrome(scheme) {
        return scheme.isDark ? 30 : 70
      }
      return 30
    },
    background: { scheme in
      return primaryFixedDim
    }
  )

  static let secondaryFixed: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.secondaryPalette
    },
    tone: { scheme in
      if _isMonochrome(scheme) {
        return 80
      }
      return 90
    },
    background: { scheme in
      return highestSurface(scheme)
    }
  )

  static let secondaryFixedDim: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.secondaryPalette
    },
    tone: { scheme in
      if _isMonochrome(scheme) {
        return 70
      }
      return 80
    },
    background: { scheme in
      return highestSurface(scheme)
    }
  )

  static let onSecondaryFixed: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.secondaryPalette
    },
    tone: { scheme in
      return 10
    },
    background: { scheme in
      return secondaryFixedDim
    }
  )

  static let onSecondaryFixedVariant: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.secondaryPalette
    },
    tone: { scheme in
      if _isMonochrome(scheme) {
        return 25
      }
      return 30
    },
    background: { scheme in
      return secondaryFixedDim
    }
  )

  static let tertiaryFixed: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.tertiaryPalette
    },
    tone: { scheme in
      if _isMonochrome(scheme) {
        return 40
      }
      return 90
    },
    background: { scheme in
      return highestSurface(scheme)
    }
  )

  static let tertiaryFixedDim: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.tertiaryPalette
    },
    tone: { scheme in
      if _isMonochrome(scheme) {
        return 30
      }
      return 80
    },
    background: { scheme in
      return highestSurface(scheme)
    }
  )

  static let onTertiaryFixed: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.tertiaryPalette
    },
    tone: { scheme in
      if _isMonochrome(scheme) {
        return 90
      }
      return 10
    },
    background: { scheme in
      return tertiaryFixedDim
    }
  )

  static let onTertiaryFixedVariant: DynamicColor = DynamicColor.fromPalette(
    palette: { scheme in
      return scheme.tertiaryPalette
    },
    tone: { scheme in
      if _isMonochrome(scheme) {
        return 70
      }
      return 30
    },
    background: { scheme in
      return tertiaryFixedDim
    }
  )

  static private func _findDesiredChromaByTone(
    _ hue: Double, _ chroma: Double, _ tone: Double, _ byDecreasingTone: Bool
  ) -> Double {
    var answer = tone

    var closestToChroma = Hct.from(hue, chroma, tone)
    if closestToChroma.chroma < chroma {
      var chromaPeak: Double = closestToChroma.chroma
      while closestToChroma.chroma < chroma {
        answer += byDecreasingTone ? -1 : 1
        let potentialSolution = Hct.from(hue, chroma, answer)
        if chromaPeak > potentialSolution.chroma {
          break
        }
        if abs(potentialSolution.chroma - chroma) < 0.4 {
          break
        }

        let potentialDelta = abs(potentialSolution.chroma - chroma)
        let currentDelta = abs(closestToChroma.chroma - chroma)
        if potentialDelta < currentDelta {
          closestToChroma = potentialSolution
        }
        chromaPeak = max(chromaPeak, potentialSolution.chroma)
      }
    }

    return answer
  }

  static private func _performAlbers(_ prealbers: Hct, _ scheme: DynamicScheme) -> Double {
    let albersd = prealbers.inViewingConditions(viewingConditionsForAlbers(scheme))
    if DynamicColor.tonePrefersLightForeground(prealbers.tone)
      && !DynamicColor.toneAllowsLightForeground(albersd.tone)
    {
      return DynamicColor.enableLightForeground(prealbers.tone)
    } else {
      return DynamicColor.enableLightForeground(albersd.tone)
    }
  }
}
