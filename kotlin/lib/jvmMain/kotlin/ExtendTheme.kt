import theme.CustomColor
import theme.Theme
import utils.ThemeUtils
import java.awt.Image
import java.awt.image.BufferedImage
import java.awt.image.DataBufferByte

fun Image.toBufferedImage(): BufferedImage {
    if (this is BufferedImage) {
        return this
    }
    val bufferedImage = BufferedImage(this.getWidth(null), this.getHeight(null), BufferedImage.TYPE_INT_ARGB)

    val graphics2D = bufferedImage.createGraphics()
    graphics2D.drawImage(this, 0, 0, null)
    graphics2D.dispose()

    return bufferedImage
}

fun ThemeUtils.themeFromImage(image: Image, vararg customColors: CustomColor = emptyArray()): Theme {
    val img = image.toBufferedImage()
    val pixels = (img.raster.dataBuffer as DataBufferByte).data
    val hasAlphaChannel = img.alphaRaster != null

    return byteArrayToTheme(pixels, hasAlphaChannel, *customColors)
}

fun Image.createTheme(vararg customColors: CustomColor = emptyArray()) = ThemeUtils.themeFromImage(this, *customColors)
