package common

internal fun interface BiFunction<T, U, R> {

    fun apply(t: T, u: U): R

    fun <V> andThen(after: Function<in R, out V>): BiFunction<T, U, V> {
        return BiFunction { t: T, u: U -> after.apply(apply(t, u)) }
    }
}
