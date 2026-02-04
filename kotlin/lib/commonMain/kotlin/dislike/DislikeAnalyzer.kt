package dislike

import hct.Hct
import kotlin.math.roundToInt

/**
 * Check and/or fix universally disliked colors.
 *
 * <p>Color science studies of color preference indicate universal distaste for dark yellow-greens,
 * and also show this is correlated to distate for biological waste and rotting food.
 *
 * <p>See Palmer and Schloss, 2010 or Schloss and Palmer's Chapter 21 in Handbook of Color
 * Psychology (2015).
 */
object DislikeAnalyzer {

    /**
     * Returns true if color is disliked.
     *
     *
     * Disliked is defined as a dark yellow-green that is not neutral.
     */
    fun isDisliked(hct: Hct): Boolean {
        val huePasses = hct.hue.roundToInt() >= 90.0 && hct.hue.roundToInt() <= 111.0
        val chromaPasses = hct.chroma.roundToInt() > 16.0
        val tonePasses = hct.tone.roundToInt() < 70.0
        return huePasses && chromaPasses && tonePasses
    }

    /** If color is disliked, lighten it to make it likable.  */
    fun fixIfDisliked(hct: Hct): Hct {
        return if (isDisliked(hct)) {
            Hct.from(hct.hue, hct.chroma, 70.0)
        } else hct
    }
}
