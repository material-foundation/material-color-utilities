package quantize

/** An interface to allow use of different color spaces by quantizers. */
interface PointProvider {
    fun fromInt(argb: Int): DoubleArray?
    fun toInt(point: DoubleArray?): Int
    fun distance(a: DoubleArray?, b: DoubleArray?): Double
}
