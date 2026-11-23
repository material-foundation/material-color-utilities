package scheme

import hct.Hct
import palettes.TonalPalette

/** A theme that's slightly more chromatic than monochrome, which is purely black / white / gray. */
class SchemeNeutral(sourceColorHct: Hct, isDark: Boolean, contrastLevel: Double) :
    DynamicScheme(
        sourceColorHct,
        Variant.NEUTRAL,
        isDark,
        contrastLevel,
        TonalPalette.fromHueAndChroma(sourceColorHct.hue, 12.0),
        TonalPalette.fromHueAndChroma(sourceColorHct.hue, 8.0),
        TonalPalette.fromHueAndChroma(sourceColorHct.hue, 16.0),
        TonalPalette.fromHueAndChroma(sourceColorHct.hue, 2.0),
        TonalPalette.fromHueAndChroma(sourceColorHct.hue, 2.0)
    )
