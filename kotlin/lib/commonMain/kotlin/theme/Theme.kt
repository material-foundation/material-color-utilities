package theme

import palettes.TonalPalette
import scheme.Scheme

data class Theme(
    val source: Int,
    val schemes: Schemes,
    val palettes: Palettes,
    val customColors: Collection<CustomColorGroup> = emptyList()
) {
    constructor(
        source: Int,
        schemes: Schemes,
        palettes: Palettes,
        customColors: Array<CustomColorGroup>
    ) : this(source, schemes, palettes, customColors.toList())

    fun custom(name: String): CustomColorGroup {
        return customColors.firstOrNull { it.color.name == name } ?: customColors.first { it.color.name.equals(name, true) }
    }
}

data class Schemes(
    val light: Scheme,
    val dark: Scheme
)

data class Palettes(
    val primary: TonalPalette,
    val secondary: TonalPalette,
    val tertiary: TonalPalette,
    val neutral: TonalPalette,
    val neutralVariant: TonalPalette,
    val error: TonalPalette,
)

data class CustomColor(
    val value: Int,
    val name: String,
    val blend: Boolean
)

data class ColorGroup(
    val color: Int,
    val onColor: Int,
    val colorContainer: Int,
    val onColorContainer: Int
)

data class CustomColorGroup(
    val color: CustomColor,
    val value: Int,
    val light: ColorGroup,
    val dark: ColorGroup
)
