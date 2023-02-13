package scheme

import hct.Hct
import palettes.TonalPalette

/** A monochrome theme, colors are purely black / white / gray. */
class SchemeMonochrome(sourceColorHct: Hct, isDark: Boolean, contrastLevel: Double) :
    DynamicScheme(
        sourceColorHct,
        Variant.MONOCHROME,
        isDark,
        contrastLevel,
        TonalPalette.fromHueAndChroma(sourceColorHct.hue, 0.0),
        TonalPalette.fromHueAndChroma(sourceColorHct.hue, 0.0),
        TonalPalette.fromHueAndChroma(sourceColorHct.hue, 0.0),
        TonalPalette.fromHueAndChroma(sourceColorHct.hue, 0.0),
        TonalPalette.fromHueAndChroma(sourceColorHct.hue, 0.0)
    )
