package quantize

/** Represents result of a quantizer run */
class QuantizerResult internal constructor(val colorToCount: Map<Int, Int>)
