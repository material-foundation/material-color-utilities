package scheme

import palettes.CorePalette

/** Represents a Material color scheme, a mapping of color roles to colors. */
class Scheme {
    var primary = 0
    var onPrimary = 0
    var primaryContainer = 0
    var onPrimaryContainer = 0
    var secondary = 0
    var onSecondary = 0
    var secondaryContainer = 0
    var onSecondaryContainer = 0
    var tertiary = 0
    var onTertiary = 0
    var tertiaryContainer = 0
    var onTertiaryContainer = 0
    var error = 0
    var onError = 0
    var errorContainer = 0
    var onErrorContainer = 0
    var background = 0
    var onBackground = 0
    var surface = 0
    var onSurface = 0
    var surfaceVariant = 0
    var onSurfaceVariant = 0
    var outline = 0
    var outlineVariant = 0
    var shadow = 0
    var scrim = 0
    var inverseSurface = 0
    var inverseOnSurface = 0
    var inversePrimary = 0

    constructor()
    constructor(
        primary: Int,
        onPrimary: Int,
        primaryContainer: Int,
        onPrimaryContainer: Int,
        secondary: Int,
        onSecondary: Int,
        secondaryContainer: Int,
        onSecondaryContainer: Int,
        tertiary: Int,
        onTertiary: Int,
        tertiaryContainer: Int,
        onTertiaryContainer: Int,
        error: Int,
        onError: Int,
        errorContainer: Int,
        onErrorContainer: Int,
        background: Int,
        onBackground: Int,
        surface: Int,
        onSurface: Int,
        surfaceVariant: Int,
        onSurfaceVariant: Int,
        outline: Int,
        outlineVariant: Int,
        shadow: Int,
        scrim: Int,
        inverseSurface: Int,
        inverseOnSurface: Int,
        inversePrimary: Int
    ) : super() {
        this.primary = primary
        this.onPrimary = onPrimary
        this.primaryContainer = primaryContainer
        this.onPrimaryContainer = onPrimaryContainer
        this.secondary = secondary
        this.onSecondary = onSecondary
        this.secondaryContainer = secondaryContainer
        this.onSecondaryContainer = onSecondaryContainer
        this.tertiary = tertiary
        this.onTertiary = onTertiary
        this.tertiaryContainer = tertiaryContainer
        this.onTertiaryContainer = onTertiaryContainer
        this.error = error
        this.onError = onError
        this.errorContainer = errorContainer
        this.onErrorContainer = onErrorContainer
        this.background = background
        this.onBackground = onBackground
        this.surface = surface
        this.onSurface = onSurface
        this.surfaceVariant = surfaceVariant
        this.onSurfaceVariant = onSurfaceVariant
        this.outline = outline
        this.outlineVariant = outlineVariant
        this.shadow = shadow
        this.scrim = scrim
        this.inverseSurface = inverseSurface
        this.inverseOnSurface = inverseOnSurface
        this.inversePrimary = inversePrimary
    }

    fun withPrimary(primary: Int): Scheme {
        this.primary = primary
        return this
    }

    fun withOnPrimary(onPrimary: Int): Scheme {
        this.onPrimary = onPrimary
        return this
    }

    fun withPrimaryContainer(primaryContainer: Int): Scheme {
        this.primaryContainer = primaryContainer
        return this
    }

    fun withOnPrimaryContainer(onPrimaryContainer: Int): Scheme {
        this.onPrimaryContainer = onPrimaryContainer
        return this
    }

    fun withSecondary(secondary: Int): Scheme {
        this.secondary = secondary
        return this
    }

    fun withOnSecondary(onSecondary: Int): Scheme {
        this.onSecondary = onSecondary
        return this
    }

    fun withSecondaryContainer(secondaryContainer: Int): Scheme {
        this.secondaryContainer = secondaryContainer
        return this
    }

    fun withOnSecondaryContainer(onSecondaryContainer: Int): Scheme {
        this.onSecondaryContainer = onSecondaryContainer
        return this
    }

    fun withTertiary(tertiary: Int): Scheme {
        this.tertiary = tertiary
        return this
    }

    fun withOnTertiary(onTertiary: Int): Scheme {
        this.onTertiary = onTertiary
        return this
    }

    fun withTertiaryContainer(tertiaryContainer: Int): Scheme {
        this.tertiaryContainer = tertiaryContainer
        return this
    }

    fun withOnTertiaryContainer(onTertiaryContainer: Int): Scheme {
        this.onTertiaryContainer = onTertiaryContainer
        return this
    }

    fun withError(error: Int): Scheme {
        this.error = error
        return this
    }

    fun withOnError(onError: Int): Scheme {
        this.onError = onError
        return this
    }

    fun withErrorContainer(errorContainer: Int): Scheme {
        this.errorContainer = errorContainer
        return this
    }

    fun withOnErrorContainer(onErrorContainer: Int): Scheme {
        this.onErrorContainer = onErrorContainer
        return this
    }

    fun withBackground(background: Int): Scheme {
        this.background = background
        return this
    }

    fun withOnBackground(onBackground: Int): Scheme {
        this.onBackground = onBackground
        return this
    }

    fun withSurface(surface: Int): Scheme {
        this.surface = surface
        return this
    }

    fun withOnSurface(onSurface: Int): Scheme {
        this.onSurface = onSurface
        return this
    }

    fun withSurfaceVariant(surfaceVariant: Int): Scheme {
        this.surfaceVariant = surfaceVariant
        return this
    }

    fun withOnSurfaceVariant(onSurfaceVariant: Int): Scheme {
        this.onSurfaceVariant = onSurfaceVariant
        return this
    }

    fun withOutline(outline: Int): Scheme {
        this.outline = outline
        return this
    }

    fun withOutlineVariant(outlineVariant: Int): Scheme {
        this.outlineVariant = outlineVariant
        return this
    }

    fun withShadow(shadow: Int): Scheme {
        this.shadow = shadow
        return this
    }

    fun withScrim(scrim: Int): Scheme {
        this.scrim = scrim
        return this
    }

    fun withInverseSurface(inverseSurface: Int): Scheme {
        this.inverseSurface = inverseSurface
        return this
    }

    fun withInverseOnSurface(inverseOnSurface: Int): Scheme {
        this.inverseOnSurface = inverseOnSurface
        return this
    }

    fun withInversePrimary(inversePrimary: Int): Scheme {
        this.inversePrimary = inversePrimary
        return this
    }

    override fun toString(): String {
        return ("Scheme{"
                + "primary="
                + primary
                + ", onPrimary="
                + onPrimary
                + ", primaryContainer="
                + primaryContainer
                + ", onPrimaryContainer="
                + onPrimaryContainer
                + ", secondary="
                + secondary
                + ", onSecondary="
                + onSecondary
                + ", secondaryContainer="
                + secondaryContainer
                + ", onSecondaryContainer="
                + onSecondaryContainer
                + ", tertiary="
                + tertiary
                + ", onTertiary="
                + onTertiary
                + ", tertiaryContainer="
                + tertiaryContainer
                + ", onTertiaryContainer="
                + onTertiaryContainer
                + ", error="
                + error
                + ", onError="
                + onError
                + ", errorContainer="
                + errorContainer
                + ", onErrorContainer="
                + onErrorContainer
                + ", background="
                + background
                + ", onBackground="
                + onBackground
                + ", surface="
                + surface
                + ", onSurface="
                + onSurface
                + ", surfaceVariant="
                + surfaceVariant
                + ", onSurfaceVariant="
                + onSurfaceVariant
                + ", outline="
                + outline
                + ", outlineVariant="
                + outlineVariant
                + ", shadow="
                + shadow
                + ", scrim="
                + scrim
                + ", inverseSurface="
                + inverseSurface
                + ", inverseOnSurface="
                + inverseOnSurface
                + ", inversePrimary="
                + inversePrimary
                + '}')
    }

    override fun equals(other: Any?): Boolean {
        if (this === other) {
            return true
        }
        if (other !is Scheme) {
            return false
        }
        if (!super.equals(other)) {
            return false
        }
        val scheme = other
        if (primary != scheme.primary) {
            return false
        }
        if (onPrimary != scheme.onPrimary) {
            return false
        }
        if (primaryContainer != scheme.primaryContainer) {
            return false
        }
        if (onPrimaryContainer != scheme.onPrimaryContainer) {
            return false
        }
        if (secondary != scheme.secondary) {
            return false
        }
        if (onSecondary != scheme.onSecondary) {
            return false
        }
        if (secondaryContainer != scheme.secondaryContainer) {
            return false
        }
        if (onSecondaryContainer != scheme.onSecondaryContainer) {
            return false
        }
        if (tertiary != scheme.tertiary) {
            return false
        }
        if (onTertiary != scheme.onTertiary) {
            return false
        }
        if (tertiaryContainer != scheme.tertiaryContainer) {
            return false
        }
        if (onTertiaryContainer != scheme.onTertiaryContainer) {
            return false
        }
        if (error != scheme.error) {
            return false
        }
        if (onError != scheme.onError) {
            return false
        }
        if (errorContainer != scheme.errorContainer) {
            return false
        }
        if (onErrorContainer != scheme.onErrorContainer) {
            return false
        }
        if (background != scheme.background) {
            return false
        }
        if (onBackground != scheme.onBackground) {
            return false
        }
        if (surface != scheme.surface) {
            return false
        }
        if (onSurface != scheme.onSurface) {
            return false
        }
        if (surfaceVariant != scheme.surfaceVariant) {
            return false
        }
        if (onSurfaceVariant != scheme.onSurfaceVariant) {
            return false
        }
        if (outline != scheme.outline) {
            return false
        }
        if (outlineVariant != scheme.outlineVariant) {
            return false
        }
        if (shadow != scheme.shadow) {
            return false
        }
        if (scrim != scheme.scrim) {
            return false
        }
        if (inverseSurface != scheme.inverseSurface) {
            return false
        }
        if (inverseOnSurface != scheme.inverseOnSurface) {
            return false
        }
        return if (inversePrimary != scheme.inversePrimary) {
            false
        } else true
    }

    override fun hashCode(): Int {
        var result = super.hashCode()
        result = 31 * result + primary
        result = 31 * result + onPrimary
        result = 31 * result + primaryContainer
        result = 31 * result + onPrimaryContainer
        result = 31 * result + secondary
        result = 31 * result + onSecondary
        result = 31 * result + secondaryContainer
        result = 31 * result + onSecondaryContainer
        result = 31 * result + tertiary
        result = 31 * result + onTertiary
        result = 31 * result + tertiaryContainer
        result = 31 * result + onTertiaryContainer
        result = 31 * result + error
        result = 31 * result + onError
        result = 31 * result + errorContainer
        result = 31 * result + onErrorContainer
        result = 31 * result + background
        result = 31 * result + onBackground
        result = 31 * result + surface
        result = 31 * result + onSurface
        result = 31 * result + surfaceVariant
        result = 31 * result + onSurfaceVariant
        result = 31 * result + outline
        result = 31 * result + outlineVariant
        result = 31 * result + shadow
        result = 31 * result + scrim
        result = 31 * result + inverseSurface
        result = 31 * result + inverseOnSurface
        result = 31 * result + inversePrimary
        return result
    }

    companion object {
        fun light(argb: Int): Scheme {
            return lightFromCorePalette(CorePalette.of(argb))
        }

        fun dark(argb: Int): Scheme {
            return darkFromCorePalette(CorePalette.of(argb))
        }

        fun lightContent(argb: Int): Scheme {
            return lightFromCorePalette(CorePalette.contentOf(argb))
        }

        fun darkContent(argb: Int): Scheme {
            return darkFromCorePalette(CorePalette.contentOf(argb))
        }

        private fun lightFromCorePalette(core: CorePalette): Scheme {
            return Scheme()
                .withPrimary(core.a1.tone(40))
                .withOnPrimary(core.a1.tone(100))
                .withPrimaryContainer(core.a1.tone(90))
                .withOnPrimaryContainer(core.a1.tone(10))
                .withSecondary(core.a2.tone(40))
                .withOnSecondary(core.a2.tone(100))
                .withSecondaryContainer(core.a2.tone(90))
                .withOnSecondaryContainer(core.a2.tone(10))
                .withTertiary(core.a3.tone(40))
                .withOnTertiary(core.a3.tone(100))
                .withTertiaryContainer(core.a3.tone(90))
                .withOnTertiaryContainer(core.a3.tone(10))
                .withError(core.error.tone(40))
                .withOnError(core.error.tone(100))
                .withErrorContainer(core.error.tone(90))
                .withOnErrorContainer(core.error.tone(10))
                .withBackground(core.n1.tone(99))
                .withOnBackground(core.n1.tone(10))
                .withSurface(core.n1.tone(99))
                .withOnSurface(core.n1.tone(10))
                .withSurfaceVariant(core.n2.tone(90))
                .withOnSurfaceVariant(core.n2.tone(30))
                .withOutline(core.n2.tone(50))
                .withOutlineVariant(core.n2.tone(80))
                .withShadow(core.n1.tone(0))
                .withScrim(core.n1.tone(0))
                .withInverseSurface(core.n1.tone(20))
                .withInverseOnSurface(core.n1.tone(95))
                .withInversePrimary(core.a1.tone(80))
        }

        private fun darkFromCorePalette(core: CorePalette): Scheme {
            return Scheme()
                .withPrimary(core.a1.tone(80))
                .withOnPrimary(core.a1.tone(20))
                .withPrimaryContainer(core.a1.tone(30))
                .withOnPrimaryContainer(core.a1.tone(90))
                .withSecondary(core.a2.tone(80))
                .withOnSecondary(core.a2.tone(20))
                .withSecondaryContainer(core.a2.tone(30))
                .withOnSecondaryContainer(core.a2.tone(90))
                .withTertiary(core.a3.tone(80))
                .withOnTertiary(core.a3.tone(20))
                .withTertiaryContainer(core.a3.tone(30))
                .withOnTertiaryContainer(core.a3.tone(90))
                .withError(core.error.tone(80))
                .withOnError(core.error.tone(20))
                .withErrorContainer(core.error.tone(30))
                .withOnErrorContainer(core.error.tone(80))
                .withBackground(core.n1.tone(10))
                .withOnBackground(core.n1.tone(90))
                .withSurface(core.n1.tone(10))
                .withOnSurface(core.n1.tone(90))
                .withSurfaceVariant(core.n2.tone(30))
                .withOnSurfaceVariant(core.n2.tone(80))
                .withOutline(core.n2.tone(60))
                .withOutlineVariant(core.n2.tone(30))
                .withShadow(core.n1.tone(0))
                .withScrim(core.n1.tone(0))
                .withInverseSurface(core.n1.tone(90))
                .withInverseOnSurface(core.n1.tone(20))
                .withInversePrimary(core.a1.tone(40))
        }
    }
}
