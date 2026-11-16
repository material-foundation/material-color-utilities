/*
 * Copyright 2026 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package quantize

/**
 * The distinct colors of [pixels], in the order in which they first appear, with how many pixels
 * have each color: the same entries, in the same order, as a `LinkedHashMap<Int, Int>` that counts
 * the pixels, without boxing a color or a count.
 *
 * Colors are found with an open-addressing hash table of indices into [colors], which doubles
 * whenever it is more than half full, so that its size follows the number of distinct colors rather
 * than of pixels. It holds up to 2^29 distinct colors.
 */
internal class PixelCounts(pixels: IntArray) {
  /** The distinct colors, in order of first appearance, in the first [size] entries. */
  var colors: IntArray = IntArray(INITIAL_CAPACITY)
    private set

  /** How many pixels have each of [colors], in the first [size] entries. */
  var counts: IntArray = IntArray(INITIAL_CAPACITY)
    private set

  /** How many distinct colors there are. */
  var size: Int = 0
    private set

  /** One more than the index in [colors] of each slot's color, or 0 for an empty slot. */
  private var slots = IntArray(INITIAL_CAPACITY * 2)

  /** The number of bits of a slot index: the table has `1 shl bits` slots. */
  private var bits = (INITIAL_CAPACITY * 2).countTrailingZeroBits()

  init {
    for (pixel in pixels) {
      add(pixel)
    }
  }

  private fun add(pixel: Int) {
    val mask = (1 shl bits) - 1
    var slot = slotOf(pixel)
    while (true) {
      val entry = slots[slot]
      if (entry == 0) {
        break
      }
      if (colors[entry - 1] == pixel) {
        counts[entry - 1]++
        return
      }
      slot = (slot + 1) and mask
    }
    if (size == colors.size) {
      colors = colors.copyOf(size * 2)
      counts = counts.copyOf(size * 2)
    }
    colors[size] = pixel
    counts[size] = 1
    size++
    slots[slot] = size
    if (size * 2 > slots.size) {
      grow()
    }
  }

  /** Doubles the table, and puts every color back in it. */
  private fun grow() {
    bits++
    slots = IntArray(1 shl bits)
    val mask = (1 shl bits) - 1
    for (index in 0 until size) {
      var slot = slotOf(colors[index])
      while (slots[slot] != 0) {
        slot = (slot + 1) and mask
      }
      slots[slot] = index + 1
    }
  }

  /**
   * The slot where the search for [color] starts: Fibonacci hashing, from the product's top bits.
   */
  private fun slotOf(color: Int): Int = (color * FIBONACCI_MULTIPLIER) ushr (Int.SIZE_BITS - bits)

  private companion object {
    /** The number of distinct colors that the arrays first hold. */
    const val INITIAL_CAPACITY = 256

    /** 2^32 divided by the golden ratio, as an `Int`. */
    const val FIBONACCI_MULTIPLIER = -0x61c88647
  }
}
