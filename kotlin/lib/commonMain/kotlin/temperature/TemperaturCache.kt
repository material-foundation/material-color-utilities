package temperature

import hct.Hct
import utils.ColorUtils.labFromArgb
import utils.MathUtils
import utils.MathUtils.sanitizeDegreesDouble
import utils.MathUtils.sanitizeDegreesInt
import kotlin.collections.ArrayList
import kotlin.collections.HashMap
import kotlin.math.*

/**
 * Design utilities using color temperature theory.
 *
 * <p>Analogous colors, complementary color, and cache to efficiently, lazily, generate data for
 * calculations when needed.
 */
class TemperatureCache(private val input: Hct) {
    private var precomputedComplement: Hct? = null
    private var precomputedHctsByTemp: List<Hct>? = null
    private var precomputedHctsByHue: List<Hct>? = null
    private var precomputedTempsByHct: Map<Hct, Double>? = null

    val complement: Hct?
        /**
         * A color that complements the input color aesthetically.
         *
         *
         * In art, this is usually described as being across the color wheel. History of this shows
         * intent as a color that is just as cool-warm as the input color is warm-cool.
         */
        get() {
            if (precomputedComplement != null) {
                return precomputedComplement
            }
            val coldestHue = coldest.hue
            val coldestTemp = tempsByHct!![coldest]!!
            val warmestHue = warmest.hue
            val warmestTemp = tempsByHct!![warmest]!!
            val range = warmestTemp - coldestTemp
            val startHueIsColdestToWarmest = isBetween(input.hue, coldestHue, warmestHue)
            val startHue = if (startHueIsColdestToWarmest) warmestHue else coldestHue
            val endHue = if (startHueIsColdestToWarmest) coldestHue else warmestHue
            val directionOfRotation = 1.0
            var smallestError = 1000.0
            var answer: Hct? = hctsByHue!![input.hue.roundToInt()]
            val complementRelativeTemp = 1.0 - getRelativeTemperature(input)
            // Find the color in the other section, closest to the inverse percentile
            // of the input color. This is the complement.
            var hueAddend = 0.0
            while (hueAddend <= 360.0) {
                val hue = sanitizeDegreesDouble(
                    startHue + directionOfRotation * hueAddend
                )
                if (!isBetween(hue, startHue, endHue)) {
                    hueAddend += 1.0
                    continue
                }
                val possibleAnswer = hctsByHue!![hue.roundToInt()]
                val relativeTemp = (tempsByHct!![possibleAnswer]!! - coldestTemp) / range
                val error = abs(complementRelativeTemp - relativeTemp)
                if (error < smallestError) {
                    smallestError = error
                    answer = possibleAnswer
                }
                hueAddend += 1.0
            }
            precomputedComplement = answer
            return precomputedComplement
        }
    val analogousColors: List<Hct>
        /**
         * 5 colors that pair well with the input color.
         *
         *
         * The colors are equidistant in temperature and adjacent in hue.
         */
        get() = getAnalogousColors(5, 12)

    /**
     * A set of colors with differing hues, equidistant in temperature.
     *
     *
     * In art, this is usually described as a set of 5 colors on a color wheel divided into 12
     * sections. This method allows provision of either of those values.
     *
     *
     * Behavior is undefined when count or divisions is 0. When divisions < count, colors repeat.
     *
     * @param count The number of colors to return, includes the input color.
     * @param divisions The number of divisions on the color wheel.
     */
    fun getAnalogousColors(count: Int, divisions: Int): List<Hct> {
        // The starting hue is the hue of the input color.
        val startHue = input.hue.roundToInt().toInt()
        val startHct = hctsByHue!![startHue]
        var lastTemp = getRelativeTemperature(startHct)
        val allColors: MutableList<Hct> = ArrayList()
        allColors.add(startHct)
        var absoluteTotalTempDelta = 0.0
        for (i in 0..359) {
            val hue = sanitizeDegreesInt(startHue + i)
            val hct = hctsByHue!![hue]
            val temp = getRelativeTemperature(hct)
            val tempDelta = abs(temp - lastTemp)
            lastTemp = temp
            absoluteTotalTempDelta += tempDelta
        }
        var hueAddend = 1
        val tempStep = absoluteTotalTempDelta / divisions.toDouble()
        var totalTempDelta = 0.0
        lastTemp = getRelativeTemperature(startHct)
        while (allColors.size < divisions) {
            val hue = sanitizeDegreesInt(startHue + hueAddend)
            val hct = hctsByHue!![hue]
            val temp = getRelativeTemperature(hct)
            val tempDelta = abs(temp - lastTemp)
            totalTempDelta += tempDelta
            var desiredTotalTempDeltaForIndex = allColors.size * tempStep
            var indexSatisfied = totalTempDelta >= desiredTotalTempDeltaForIndex
            var indexAddend = 1
            // Keep adding this hue to the answers until its temperature is
            // insufficient. This ensures consistent behavior when there aren't
            // `divisions` discrete steps between 0 and 360 in hue with `tempStep`
            // delta in temperature between them.
            //
            // For example, white and black have no analogues: there are no other
            // colors at T100/T0. Therefore, they should just be added to the array
            // as answers.
            while (indexSatisfied && allColors.size < divisions) {
                allColors.add(hct)
                desiredTotalTempDeltaForIndex = (allColors.size + indexAddend) * tempStep
                indexSatisfied = totalTempDelta >= desiredTotalTempDeltaForIndex
                indexAddend++
            }
            lastTemp = temp
            hueAddend++
            if (hueAddend > 360) {
                while (allColors.size < divisions) {
                    allColors.add(hct)
                }
                break
            }
        }
        val answers: MutableList<Hct> = ArrayList()
        answers.add(input)
        val ccwCount = floor((count.toDouble() - 1.0) / 2.0).toInt()
        for (i in 1 until ccwCount + 1) {
            var index = 0 - i
            while (index < 0) {
                index += allColors.size
            }
            if (index >= allColors.size) {
                index %= allColors.size
            }
            answers.add(0, allColors[index])
        }
        val cwCount = count - ccwCount - 1
        for (i in 1 until cwCount + 1) {
            var index = i
            while (index < 0) {
                index += allColors.size
            }
            if (index >= allColors.size) {
                index %= allColors.size
            }
            answers.add(allColors[index])
        }
        return answers
    }

    /**
     * Temperature relative to all colors with the same chroma and tone.
     *
     * @param hct HCT to find the relative temperature of.
     * @return Value on a scale from 0 to 1.
     */
    fun getRelativeTemperature(hct: Hct): Double {
        val range = tempsByHct!![warmest]!! - tempsByHct!![coldest]!!
        val differenceFromColdest = tempsByHct!![hct]!! - tempsByHct!![coldest]!!
        // Handle when there's no difference in temperature between warmest and
        // coldest: for example, at T100, only one color is available, white.
        return if (range == 0.0) {
            0.5
        } else differenceFromColdest / range
    }

    private val coldest: Hct
        /** Coldest color with same chroma and tone as input.  */
        private get() = hctsByTemp!![0]
    private val hctsByHue: List<Hct>?
        /**
         * HCTs for all colors with the same chroma/tone as the input.
         *
         *
         * Sorted by hue, ex. index 0 is hue 0.
         */
        private get() {
            if (precomputedHctsByHue != null) {
                return precomputedHctsByHue
            }
            val hcts: MutableList<Hct> = ArrayList()
            var hue = 0.0
            while (hue <= 360.0) {
                val colorAtHue = Hct.from(hue, input.chroma, input.tone)
                hcts.add(colorAtHue)
                hue += 1.0
            }
            precomputedHctsByHue = hcts.toList()
            return precomputedHctsByHue
        }
    private val hctsByTemp: List<Hct>?
        /**
         * HCTs for all colors with the same chroma/tone as the input.
         *
         *
         * Sorted from coldest first to warmest last.
         */
        private get() {
            if (precomputedHctsByTemp != null) {
                return precomputedHctsByTemp
            }
            val hcts: MutableList<Hct> = ArrayList(
                hctsByHue ?: emptyList()
            )
            hcts.add(input)
            hcts.sortBy { arg ->
                tempsByHct!![arg]
            }
            precomputedHctsByTemp = hcts
            return precomputedHctsByTemp
        }
    private val tempsByHct: Map<Hct, Double>?
        /** Keys of HCTs in getHctsByTemp, values of raw temperature.  */
        private get() {
            if (precomputedTempsByHct != null) {
                return precomputedTempsByHct
            }
            val allHcts: MutableList<Hct> = ArrayList(
                hctsByHue ?: emptyList()
            )
            allHcts.add(input)
            val temperaturesByHct: MutableMap<Hct, Double> = HashMap()
            for (hct in allHcts) {
                temperaturesByHct[hct] = rawTemperature(hct)
            }
            precomputedTempsByHct = temperaturesByHct
            return precomputedTempsByHct
        }
    private val warmest: Hct
        /** Warmest color with same chroma and tone as input.  */
        private get() = hctsByTemp!![hctsByTemp!!.size - 1]

    companion object {
        /**
         * Value representing cool-warm factor of a color. Values below 0 are considered cool, above,
         * warm.
         *
         *
         * Color science has researched emotion and harmony, which art uses to select colors. Warm-cool
         * is the foundation of analogous and complementary colors. See: - Li-Chen Ou's Chapter 19 in
         * Handbook of Color Psychology (2015). - Josef Albers' Interaction of Color chapters 19 and 21.
         *
         *
         * Implementation of Ou, Woodcock and Wright's algorithm, which uses Lab/LCH color space.
         * Return value has these properties:<br></br>
         * - Values below 0 are cool, above 0 are warm.<br></br>
         * - Lower bound: -9.66. Chroma is infinite. Assuming max of Lab chroma 130.<br></br>
         * - Upper bound: 8.61. Chroma is infinite. Assuming max of Lab chroma 130.
         */
        fun rawTemperature(color: Hct): Double {
            val lab = labFromArgb(color.toInt())
            val hue = sanitizeDegreesDouble(
                MathUtils.toDegrees(
                    atan2(
                        lab[2], lab[1]
                    )
                )
            )
            val chroma = hypot(lab[1], lab[2])
            return (-0.5
                    + (0.02
                    * chroma.pow(1.07)
                    * cos(MathUtils.toRadians(sanitizeDegreesDouble(hue - 50.0)))))
        }

        /** Determines if an angle is between two other angles, rotating clockwise.  */
        private fun isBetween(angle: Double, a: Double, b: Double): Boolean {
            return if (a < b) {
                angle in a..b
            } else a <= angle || angle <= b
        }
    }
}
