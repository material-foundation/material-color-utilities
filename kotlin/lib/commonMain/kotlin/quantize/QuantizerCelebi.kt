package quantize

/**
 * An image quantizer that improves on the quality of a standard K-Means algorithm by setting the
 * K-Means initial state to the output of a Wu quantizer, instead of random centroids. Improves on
 * speed by several optimizations, as implemented in Wsmeans, or Weighted Square Means, K-Means with
 * those optimizations.
 *
 * <p>This algorithm was designed by M. Emre Celebi, and was found in their 2011 paper, Improving
 * the Performance of K-Means for Color Quantization. https://arxiv.org/abs/1101.0395
 */
object QuantizerCelebi {
    /**
     * Reduce the number of colors needed to represented the input, minimizing the difference between
     * the original image and the recolored image.
     *
     * @param pixels Colors in ARGB format.
     * @param maxColors The number of colors to divide the image into. A lower number of colors may be
     * returned.
     * @return Map with keys of colors in ARGB format, and values of number of pixels in the original
     * image that correspond to the color in the quantized image.
     */
    fun quantize(pixels: IntArray, maxColors: Int): Map<Int, Int> {
        val wu = QuantizerWu()
        val wuResult: QuantizerResult = wu.quantize(pixels, maxColors)
        val wuClustersAsObjects = wuResult.colorToCount.keys
        var index = 0
        val wuClusters = IntArray(wuClustersAsObjects.size)
        for (argb in wuClustersAsObjects) {
            wuClusters[index++] = argb
        }
        return QuantizerWsmeans.quantize(pixels, wuClusters, maxColors)
    }
}
