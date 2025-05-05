package scheme

import hct.Hct
import palettes.TonalPalette
import utils.MathUtils.sanitizeDegreesDouble

/** A calm theme, sedated colors that aren't particularly chromatic. */
class SchemeTonalSpot(sourceColorHct: Hct, isDark: Boolean, contrastLevel: Double) : DynamicScheme(
    sourceColorHct,
    Variant.TONAL_SPOT,
    isDark,
    contrastLevel,
    TonalPalette.fromHueAndChroma(sourceColorHct.hue, 40.0),
    TonalPalette.fromHueAndChroma(sourceColorHct.hue, 16.0),
    TonalPalette.fromHueAndChroma(
        sanitizeDegreesDouble(sourceColorHct.hue + 60.0), 24.0
    ),
    TonalPalette.fromHueAndChroma(sourceColorHct.hue, 6.0),
    TonalPalette.fromHueAndChroma(sourceColorHct.hue, 8.0)
)
