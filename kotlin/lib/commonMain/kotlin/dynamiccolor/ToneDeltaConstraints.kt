package dynamiccolor

/**
 * Documents a constraint between two DynamicColors, in which their tones must have a certain
 * distance from each other.
 */
internal class ToneDeltaConstraint(val delta: Double, keepAway: DynamicColor, keepAwayPolarity: TonePolarity) {
    val keepAway: DynamicColor
    val keepAwayPolarity: TonePolarity

    /**
     * @param delta the difference in tone required
     * @param keepAway the color to distance in tone from
     * @param keepAwayPolarity whether the color to keep away from must be lighter, darker, or no
     * preference, in which case it should
     */
    init {
        this.keepAway = keepAway
        this.keepAwayPolarity = keepAwayPolarity
    }
}
