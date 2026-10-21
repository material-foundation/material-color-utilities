package scheme

import hct.Hct
import palettes.TonalPalette
import utils.MathUtils.sanitizeDegreesDouble

/** A playful theme - the source color's hue does not appear in the theme. */
class SchemeExpressive(sourceColorHct: Hct, isDark: Boolean, contrastLevel: Double) :
    DynamicScheme(
        sourceColorHct,
        Variant.EXPRESSIVE,
        isDark,
        contrastLevel,
        TonalPalette.fromHueAndChroma(
            sanitizeDegreesDouble(sourceColorHct.hue + 120.0), 40.0
        ),
        TonalPalette.fromHueAndChroma(
            getRotatedHue(sourceColorHct, HUES, SECONDARY_ROTATIONS), 24.0
        ),
        TonalPalette.fromHueAndChroma(
            getRotatedHue(sourceColorHct, HUES, TERTIARY_ROTATIONS), 32.0
        ),
        TonalPalette.fromHueAndChroma(sourceColorHct.hue, 8.0),
        TonalPalette.fromHueAndChroma(sourceColorHct.hue, 12.0)
    ) {
    companion object {
        // NOMUTANTS--arbitrary increments/decrements, correctly, still passes tests.
        private val HUES = doubleArrayOf(0.0, 21.0, 51.0, 121.0, 151.0, 191.0, 271.0, 321.0, 360.0)
        private val SECONDARY_ROTATIONS = doubleArrayOf(45.0, 95.0, 45.0, 20.0, 45.0, 90.0, 45.0, 45.0, 45.0)
        private val TERTIARY_ROTATIONS = doubleArrayOf(120.0, 120.0, 20.0, 45.0, 20.0, 15.0, 20.0, 120.0, 120.0)
    }
}
