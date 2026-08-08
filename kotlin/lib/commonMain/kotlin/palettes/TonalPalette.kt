package palettes

import hct.Hct

/**
 * A convenience class for retrieving colors that are constant in hue and chroma, but vary in tone.
 */
class TonalPalette private constructor(var hue: Double, var chroma: Double) {
    var cache: MutableMap<Int, Int> = HashMap()

    /**
     * Create an ARGB color with HCT hue and chroma of this Tones instance, and the provided HCT tone.
     *
     * @param tone HCT tone, measured from 0 to 100.
     * @return ARGB representation of a color with that tone.
     */
    // AndroidJdkLibsChecker is higher priority than ComputeIfAbsentUseValue (b/119581923)
    fun tone(tone: Int): Int {
        var color = cache[tone]
        if (color == null) {
            color = Hct.from(hue, chroma, tone.toDouble()).toInt()
            cache[tone] = color
        }
        return color
    }

    fun getHct(tone: Double): Hct {
        return Hct.from(hue, chroma, tone)
    }

    companion object {
        /**
         * Create tones using the HCT hue and chroma from a color.
         *
         * @param argb ARGB representation of a color
         * @return Tones matching that color's hue and chroma.
         */
        fun fromInt(argb: Int): TonalPalette {
            return fromHct(Hct.fromInt(argb))
        }

        /**
         * Create tones using a HCT color.
         *
         * @param hct HCT representation of a color.
         * @return Tones matching that color's hue and chroma.
         */
        fun fromHct(hct: Hct): TonalPalette {
            return fromHueAndChroma(hct.hue, hct.chroma)
        }

        /**
         * Create tones from a defined HCT hue and chroma.
         *
         * @param hue HCT hue
         * @param chroma HCT chroma
         * @return Tones matching hue and chroma.
         */
        fun fromHueAndChroma(hue: Double, chroma: Double): TonalPalette {
            return TonalPalette(hue, chroma)
        }
    }
}
