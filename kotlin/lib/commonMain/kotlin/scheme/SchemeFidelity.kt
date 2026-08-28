package scheme

import dislike.DislikeAnalyzer.fixIfDisliked
import hct.Hct
import palettes.TonalPalette
import temperature.TemperatureCache

/**
 * A scheme that places the source color in Scheme.primaryContainer.
 *
 * <p>Primary Container is the source color, adjusted for color relativity. It maintains constant
 * appearance in light mode and dark mode. This adds ~5 tone in light mode, and subtracts ~5 tone in
 * dark mode.
 *
 * <p>Tertiary Container is the complement to the source color, using TemperatureCache. It also
 * maintains constant appearance.
 */
class SchemeFidelity(sourceColorHct: Hct, isDark: Boolean, contrastLevel: Double) :
    DynamicScheme(
        sourceColorHct,
        Variant.FIDELITY,
        isDark,
        contrastLevel,
        TonalPalette.fromHueAndChroma(sourceColorHct.hue, sourceColorHct.chroma),
        TonalPalette.fromHueAndChroma(
            sourceColorHct.hue,
            (sourceColorHct.chroma - 32.0).coerceAtLeast(sourceColorHct.chroma * 0.5)
        ),
        TonalPalette.fromHct(
            fixIfDisliked(TemperatureCache(sourceColorHct).complement!!)
        ),
        TonalPalette.fromHueAndChroma(sourceColorHct.hue, sourceColorHct.chroma / 8.0),
        TonalPalette.fromHueAndChroma(
            sourceColorHct.hue, sourceColorHct.chroma / 8.0 + 4.0
        )
    )
