package common

internal fun interface Function<T, R> {
    fun apply(t: T): R

    fun <V> compose(before: Function<in V, out T>): Function<V, R> {
        return Function { v: V -> apply(before.apply(v)) }
    }

    fun <V> andThen(after: Function<in R, out V>): Function<T, V> {
        return Function { t: T -> after.apply(apply(t)) }
    }

    fun <T> identity(): Function<T, T> {
        return Function { t: T -> t }
    }
}
