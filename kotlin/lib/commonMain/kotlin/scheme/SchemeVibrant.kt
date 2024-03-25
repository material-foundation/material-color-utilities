package scheme

import hct.Hct
import palettes.TonalPalette

/** A loud theme, colorfulness is maximum for Primary palette, increased for others. */
class SchemeVibrant(sourceColorHct: Hct, isDark: Boolean, contrastLevel: Double) :
    DynamicScheme(
        sourceColorHct,
        Variant.VIBRANT,
        isDark,
        contrastLevel,
        TonalPalette.fromHueAndChroma(sourceColorHct.hue, 200.0),
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
        private val HUES = doubleArrayOf(0.0, 41.0, 61.0, 101.0, 131.0, 181.0, 251.0, 301.0, 360.0)
        private val SECONDARY_ROTATIONS = doubleArrayOf(18.0, 15.0, 10.0, 12.0, 15.0, 18.0, 15.0, 12.0, 12.0)
        private val TERTIARY_ROTATIONS = doubleArrayOf(35.0, 30.0, 20.0, 25.0, 30.0, 35.0, 30.0, 25.0, 25.0)
    }
}
