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

import 'package:material_color_utilities/hct/hct.dart';

/// Check and/or fix universally disliked colors.
///
/// Color science studies of color preference indicate universal distaste for
/// dark yellow-greens, and also show this is correlated to distate for
/// biological waste and rotting food.
///
/// See Palmer and Schloss, 2010 or Schloss and Palmer's Chapter 21 in Handbook
/// of Color Psychology (2015).
class DislikeAnalyzer {
  /// Returns true if [hct] is disliked.
  ///
  /// Disliked is defined as a dark yellow-green that is not neutral.
  static bool isDisliked(Hct hct) {
    final huePasses = hct.hue.round() >= 90.0 && hct.hue.round() <= 111.0;
    final chromaPasses = hct.chroma.round() > 16.0;
    final tonePasses = hct.tone.round() < 65.0;

    return huePasses && chromaPasses && tonePasses;
  }

  /// If [hct] is disliked, lighten it to make it likable.
  static Hct fixIfDisliked(Hct hct) {
    if (isDisliked(hct)) {
      return Hct.from(
        hct.hue,
        hct.chroma,
        70.0,
      );
    }

    return hct;
  }
}
