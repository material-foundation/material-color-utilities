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

package quantize;

import java.util.Arrays;

/**
 * Counts how often each color appears in an image, in the order in which the colors first appear.
 *
 * <p>This gives the same colors, counts and order as counting with a {@code LinkedHashMap<Integer,
 * Integer>}, without an object for every color and every count. The colors are kept in a flat
 * array, and an open-addressing hash table of indices into it finds a color.
 */
final class PixelCounts {
  private static final int INITIAL_CAPACITY = 256;

  /** 2^32 divided by the golden ratio, to spread the colors over the hash table. */
  private static final int FIBONACCI_MULTIPLIER = 0x9E3779B9;

  /** The distinct colors, in the order in which they first appear. Only the first size are used. */
  private int[] colors = new int[INITIAL_CAPACITY];

  /** How often each color in colors appears. */
  private int[] counts = new int[INITIAL_CAPACITY];

  private int size = 0;

  /** For each slot, the index of its color in colors plus 1, or 0 if the slot is empty. */
  private int[] slots = new int[INITIAL_CAPACITY * 2];

  /** The base-2 logarithm of the length of slots. */
  private int bits = Integer.numberOfTrailingZeros(INITIAL_CAPACITY * 2);

  /** Counts the colors in pixels, which are in ARGB format. */
  PixelCounts(int[] pixels) {
    for (int pixel : pixels) {
      add(pixel);
    }
  }

  /** The number of distinct colors. */
  int size() {
    return size;
  }

  /** The distinct colors, in the order in which they first appear. Only the first size() count. */
  int[] colors() {
    return colors;
  }

  /** How often each color in colors() appears. Only the first size() count. */
  int[] counts() {
    return counts;
  }

  private void add(int pixel) {
    int mask = (1 << bits) - 1;
    int slot = slotOf(pixel);
    while (true) {
      int entry = slots[slot];
      if (entry == 0) {
        break;
      }
      if (colors[entry - 1] == pixel) {
        counts[entry - 1]++;
        return;
      }
      slot = (slot + 1) & mask;
    }
    if (size == colors.length) {
      colors = Arrays.copyOf(colors, size * 2);
      counts = Arrays.copyOf(counts, size * 2);
    }
    colors[size] = pixel;
    counts[size] = 1;
    size++;
    slots[slot] = size;
    // Keeps the table at most half full, so that searches stay short.
    if (size * 2 > slots.length) {
      grow();
    }
  }

  private void grow() {
    bits++;
    slots = new int[1 << bits];
    int mask = (1 << bits) - 1;
    for (int index = 0; index < size; index++) {
      int slot = slotOf(colors[index]);
      while (slots[slot] != 0) {
        slot = (slot + 1) & mask;
      }
      slots[slot] = index + 1;
    }
  }

  private int slotOf(int color) {
    return (color * FIBONACCI_MULTIPLIER) >>> (Integer.SIZE - bits);
  }
}
