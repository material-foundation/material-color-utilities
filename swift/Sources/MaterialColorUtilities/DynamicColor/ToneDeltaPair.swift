// Copyright 2023 Google LLC
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

/// Describes the different in tone between colors. If there is no preference,
/// the tones at standard contrast are examined and the polarity of those is
/// attempted to be maintained.
enum TonePolarity {
  case darker
  case lighter
  case nearer
  case farther
}

/// Documents a constraint between two `DynamicColor`s, in which their tones must
/// have a certain distance from each other. Prefer a `DynamicColor` with a
/// background, this is for special cases when designers want tonal distance,
/// literally contrast, between two colors that don't have a background /
/// foreground relationship or a contrast guarantee.
public struct ToneDeltaPair {
  let subject: DynamicColor
  let basis: DynamicColor
  let delta: Double
  let polarity: TonePolarity
  let stayTogether: Bool

  /// Documents a constraint in tone distance between two `DynamicColor`s.
  ///
  /// The polarity is an adjective that describes "A", compared to "B".
  ///
  /// For instance, ToneDeltaPair(A, B, 15, 'darker', stayTogether) states that
  /// A's tone should be at least 15 darker than B's.
  ///
  /// 'nearer' and 'farther' describes closeness to the surface roles. For
  /// instance, ToneDeltaPair(A, B, 10, 'nearer', stayTogether) states that A
  /// should be 10 lighter than B in light mode, and 10 darker than B in dark
  /// mode.
  ///
  /// - Parameters:
  ///   - subject: The color role to be judged.
  ///   - basis: The role used as a basis of comparison.
  ///   - delta: Required difference between tones. Absolute value, negative
  ///     values have undefined behavior.
  ///   - polarity: The relative relation between tones of subject and basis,
  ///     as described above.
  ///   - stayTogether: Whether these two roles should stay on the same side of
  ///     the "awkward zone" (T50-59). This is necessary for certain cases where
  ///     one role has two backgrounds.
  init(
    _ subject: DynamicColor,
    _ basis: DynamicColor,
    _ delta: Double,
    polarity: TonePolarity,
    stayTogether: Bool
  ) {
    self.subject = subject
    self.basis = basis
    self.delta = delta
    self.polarity = polarity
    self.stayTogether = stayTogether
  }
}
