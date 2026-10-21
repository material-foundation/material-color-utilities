package utils

import blend.Blend
import palettes.CorePalette
import quantize.QuantizerCelebi
import scheme.Scheme
import score.Score
import theme.*

object ThemeUtils {

    fun themeFromSourceColor(source: Int, vararg customColors: CustomColor = emptyArray()): Theme {
        val palette = CorePalette.of(source)
        return Theme(
            source = source,
            schemes = Schemes(
                Scheme.light(source),
                Scheme.dark(source)
            ),
            palettes = Palettes(
                palette.a1,
                palette.a2,
                palette.a3,
                palette.n1,
                palette.n2,
                palette.error
            ),
            customColors = customColors.map { customColor(source, it) }
        )
    }

    private fun customColor(source: Int, color: CustomColor): CustomColorGroup {
        val from = color.value
        val value = if (color.blend) {
             Blend.harmonize(from, source)
        } else from
        val palette = CorePalette.of(value)
        val tones = palette.a1

        return CustomColorGroup(
            color = color,
            value = value,
            light = ColorGroup(
                color = tones.tone(40),
                onColor = tones.tone(100),
                colorContainer = tones.tone(90),
                onColorContainer = tones.tone(10)
            ),
            dark = ColorGroup(
                color = tones.tone(80),
                onColor = tones.tone(20),
                colorContainer = tones.tone(30),
                onColorContainer = tones.tone(90)
            )
        )
    }

    internal fun byteArrayToTheme(pixels: ByteArray, hasAlpha: Boolean, vararg customColors: CustomColor): Theme {
        val pixelColors: MutableList<Int> = mutableListOf()

        if (hasAlpha) {
            var pixel = 0
            while (pixel + 3 < pixels.size) {
                var argb = 0
                argb += pixels[pixel].toInt() and 0xff shl 24
                argb += pixels[pixel + 1].toInt() and 0xff
                argb += pixels[pixel + 2].toInt() and 0xff shl 8
                argb += pixels[pixel + 3].toInt() and 0xff shl 16

                pixelColors.add(argb)
                pixel += 4
            }
        } else {
            var pixel = 0
            while (pixel + 2 < pixels.size) {
                var argb = 0
                argb += -16777216
                argb += pixels[pixel].toInt() and 0xff
                argb += pixels[pixel + 1].toInt() and 0xff shl 8
                argb += pixels[pixel + 2].toInt() and 0xff shl 16

                pixelColors.add(argb)
                pixel += 3
            }
        }

        val result = QuantizerCelebi.quantize(pixelColors.toIntArray(), 128)
        val ranked = Score.score(result)
        val top = ranked[0]

        return themeFromSourceColor(top, *customColors)
    }

}
