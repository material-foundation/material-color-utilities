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
  case noPreference
}

/// Documents a constraint between two DynamicColors, in which their tones must
/// have a certain distance from each other. Prefer a DynamicColor with a
/// background, this is for special cases when designers want tonal distance,
/// literally contrast, between two colors that don't have a background /
/// foreground relationship or a contrast guarantee.
class ToneDeltaConstraint {
  /// Required difference between tones. Absolute value, negative values have
  /// undefined behavior.
  let delta: Double

  /// [DynamicColor] whose tone must be [delta] from the [DynamicColor] this
  /// constraint is attached to.
  let keepAway: DynamicColor

  /// The polarity of [keepAway] as compared to the [DynamicColor] this
  /// constraint is attached to.
  let keepAwayPolarity: TonePolarity

  init(delta: Double, keepAway: DynamicColor, keepAwayPolarity: TonePolarity) {
    self.delta = delta
    self.keepAway = keepAway
    self.keepAwayPolarity = keepAwayPolarity
  }
}
