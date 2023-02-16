/**
 * @license
 * Copyright 2022 Google LLC
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

import {DynamicColor} from './dynamic_color.js';

/**
 * Describes the different in tone between colors.
 *
 * If there is no preference, the tones at standard contrast are examined, and
 * the polarity of those is attempted to be maintained.
 */
export type TonePolarity = 'darker'|'lighter'|'no-preference';

/**
 * Documents a constraint between two DynamicColors, in which their tones must
 * have a certain distance from each other.
 *
 * Prefer a DynamicColor with a background, this is for special cases when
 * designers want tonal distance, literally contrast, between two colors that
 * don't have a background / foreground relationship or a contrast guarantee.
 */
export class ToneDeltaConstraint {
  /**
   * Documents a constraint in tone distance between two DynamicColors.
   *
   * @param delta Required difference between tones. Absolute value, negative
   * values have undefined behavior.
   * @param keepAway DynamicColor whose tone must be delta from the DynamicColor
   * constructed with this instance.
   * @param keepAwayPolarity The polarity of keepAway as compared to the
   * DynamicColor this constraint is attached to.
   */
  constructor(
      readonly delta: number, readonly keepAway: DynamicColor,
      readonly keepAwayPolarity: TonePolarity) {}
}