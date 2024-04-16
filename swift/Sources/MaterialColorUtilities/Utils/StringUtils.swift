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

import Foundation

public class StringUtils {
  /// Convert from a hex color to a argb color
  @inlinable public static func hexFromArgb(_ argb: Int, leadingHashSign: Bool = true) -> String {
    let red = ColorUtils.redFromArgb(argb)
    let green = ColorUtils.greenFromArgb(argb)
    let blue = ColorUtils.blueFromArgb(argb)
    return "\(leadingHashSign ? "#" : "")\(hex(red))\(hex(green))\(hex(blue))"
  }

  /// Convert a string containing a hex color to a argb color
  @inlinable public static func argbFromHex(_ hex: String) -> Int? {
    if hex.hasPrefix("#") {
      return Int(hex.dropFirst(), radix: 16)
    } else {
      return Int(hex, radix: 16)
    }
  }

  static public func hex(_ value: Int) -> String {
    return String(format: "%02X", value)
  }
}
