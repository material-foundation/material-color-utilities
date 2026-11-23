package scheme

import dislike.DislikeAnalyzer.fixIfDisliked
import hct.Hct
import palettes.TonalPalette
import temperature.TemperatureCache
import kotlin.math.max

/**
 * A scheme that places the source color in Scheme.primaryContainer.
 *
 * <p>Primary Container is the source color, adjusted for color relativity. It maintains constant
 * appearance in light mode and dark mode. This adds ~5 tone in light mode, and subtracts ~5 tone in
 * dark mode.
 *
 * <p>Tertiary Container is an analogous color, specifically, the analog of a color wheel divided
 * into 6, and the precise analog is the one found by increasing hue. This is a scientifically
 * grounded equivalent to rotating hue clockwise by 60 degrees. It also maintains constant
 * appearance.
 */
class SchemeContent(sourceColorHct: Hct, isDark: Boolean, contrastLevel: Double) :
    DynamicScheme(
        sourceColorHct,
        Variant.CONTENT,
        isDark,
        contrastLevel,
        TonalPalette.fromHueAndChroma(sourceColorHct.hue, sourceColorHct.chroma),
        TonalPalette.fromHueAndChroma(
            sourceColorHct.hue,
            max(sourceColorHct.chroma - 32.0, sourceColorHct.chroma * 0.5)
        ),
        TonalPalette.fromHct(
            fixIfDisliked(
                TemperatureCache(sourceColorHct)
                    .getAnalogousColors( /* count= */3,  /* divisions= */6)[2]
            )
        ),
        TonalPalette.fromHueAndChroma(sourceColorHct.hue, sourceColorHct.chroma / 8.0),
        TonalPalette.fromHueAndChroma(
            sourceColorHct.hue, sourceColorHct.chroma / 8.0 + 4.0
        )
    )
