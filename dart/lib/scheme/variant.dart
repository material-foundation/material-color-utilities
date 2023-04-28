// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// Set of themes supported by Dynamic Color.
/// Instantiate the corresponding subclass, ex. SchemeTonalSpot, to create
/// colors corresponding to the theme.
enum Variant {
  monochrome('monochrome', 'All colors are grayscale, no chroma.'),
  neutral('neutral', 'Close to grayscale, a hint of chroma.'),
  tonalSpot('tonal spot',
      'Pastel tokens, low chroma palettes (32).\nDefault Material You theme at 2021 launch.'),
  vibrant('vibrant',
      'Pastel colors, high chroma palettes. (max).\nThe primary palette\'s chroma is at maximum.\nUse Fidelity instead if tokens should alter their tone to match the palette vibrancy.'),
  expressive('expressive',
      'Pastel colors, medium chroma palettes.\nThe primary palette\'s hue is different from source color, for variety.'),
  content('content',
      'Almost identical to Fidelity.\nTokens and palettes match source color.\nPrimary Container is source color, adjusted to ensure contrast with surfaces.\n\nTertiary palette is analogue of source color.\nFound by dividing color wheel by 6, then finding the 2 colors adjacent to source.\nThe one that increases hue is used.'),
  fidelity('fidelity',
      'Tokens and palettes match source color.\nPrimary Container is source color, adjusted to ensure contrast with surfaces.\nFor example, if source color is black, it is lightened so it doesn\'t match surfaces in dark mode.\n\nTertiary palette is complement of source color.');

  final String label;
  final String description;

  const Variant(this.label, this.description);
}
