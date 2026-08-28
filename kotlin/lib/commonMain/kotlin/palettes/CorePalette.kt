package palettes

import hct.Hct
import kotlin.math.min
import kotlin.math.max

/**
 * An intermediate concept between the key color for a UI theme, and a full color scheme. 5 sets of
 * tones are generated, all except one use the same hue as the key color, and all vary in chroma.
 */
class CorePalette private constructor(argb: Int, isContent: Boolean) {
    var a1: TonalPalette
    var a2: TonalPalette
    var a3: TonalPalette
    var n1: TonalPalette
    var n2: TonalPalette
    var error: TonalPalette

    init {
        val hct = Hct.fromInt(argb)
        val hue = hct.hue
        val chroma = hct.chroma

        if (isContent) {
            a1 = TonalPalette.fromHueAndChroma(hue, chroma)
            a2 = TonalPalette.fromHueAndChroma(hue, chroma / 3.0)
            a3 = TonalPalette.fromHueAndChroma(hue + 60.0, chroma / 2.0)
            n1 = TonalPalette.fromHueAndChroma(hue, min(chroma / 12.0, 4.0))
            n2 = TonalPalette.fromHueAndChroma(hue, min(chroma / 6.0, 8.0))
        } else {
            a1 = TonalPalette.fromHueAndChroma(hue, max(48.0, chroma))
            a2 = TonalPalette.fromHueAndChroma(hue, 16.0)
            a3 = TonalPalette.fromHueAndChroma(hue + 60.0, 24.0)
            n1 = TonalPalette.fromHueAndChroma(hue, 4.0)
            n2 = TonalPalette.fromHueAndChroma(hue, 8.0)
        }
        error = TonalPalette.fromHueAndChroma(25.0, 84.0)
    }

    companion object {
        /**
         * Create key tones from a color.
         *
         * @param argb ARGB representation of a color
         */
        fun of(argb: Int): CorePalette {
            return CorePalette(argb, false)
        }

        /**
         * Create content key tones from a color.
         *
         * @param argb ARGB representation of a color
         */
        fun contentOf(argb: Int): CorePalette {
            return CorePalette(argb, true)
        }
    }
}
