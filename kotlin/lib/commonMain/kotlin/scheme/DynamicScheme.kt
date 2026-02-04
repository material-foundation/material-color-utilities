package scheme

import hct.Hct
import palettes.TonalPalette
import utils.MathUtils.sanitizeDegreesDouble

/**
 * Provides important settings for creating colors dynamically, and 6 color palettes. Requires: 1. A
 * color. (source color) 2. A theme. (Variant) 3. Whether or not its dark mode. 4. Contrast level.
 * (-1 to 1, currently contrast ratio 3.0 and 7.0)
 */
open class DynamicScheme(
    val sourceColorHct: Hct,
    val variant: Variant,
    val isDark: Boolean,
    val contrastLevel: Double,
    val primaryPalette: TonalPalette,
    val secondaryPalette: TonalPalette,
    val tertiaryPalette: TonalPalette,
    val neutralPalette: TonalPalette,
    val neutralVariantPalette: TonalPalette
) {
    val sourceColorArgb: Int = sourceColorHct.toInt()
    val errorPalette: TonalPalette = TonalPalette.fromHueAndChroma(25.0, 84.0)

    companion object {
        fun getRotatedHue(sourceColorHct: Hct, hues: DoubleArray, rotations: DoubleArray): Double {
            val sourceHue = sourceColorHct.hue
            if (rotations.size == 1) {
                return sanitizeDegreesDouble(sourceHue + rotations[0])
            }
            val size = hues.size
            for (i in 0..size - 2) {
                val thisHue = hues[i]
                val nextHue = hues[i + 1]
                if (thisHue < sourceHue && sourceHue < nextHue) {
                    return sanitizeDegreesDouble(sourceHue + rotations[i])
                }
            }
            // If this statement executes, something is wrong, there should have been a rotation
            // found using the arrays.
            return sourceHue
        }
    }
}
