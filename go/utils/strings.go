// Copyright 2021 Google LLC
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

package utils

import (
	"fmt"
	"strconv"
	"strings"
)

// HexFromArgb converts an ARGB color to a hex string.
func HexFromArgb(argb uint32) string {
	red := RedFromArgb(argb)
	green := GreenFromArgb(argb)
	blue := BlueFromArgb(argb)
	return fmt.Sprintf("#%02x%02x%02x", red, green, blue)
}

// ArgbFromHex converts a hex color string to ARGB.
// Supports formats: "#RGB", "#RRGGBB", "#AARRGGBB"
func ArgbFromHex(hex string) (uint32, error) {
	hex = strings.TrimPrefix(hex, "#")

	switch len(hex) {
	case 3:
		// RGB format - expand to RRGGBB
		r, err := strconv.ParseUint(hex[0:1], 16, 8)
		if err != nil {
			return 0, err
		}
		g, err := strconv.ParseUint(hex[1:2], 16, 8)
		if err != nil {
			return 0, err
		}
		b, err := strconv.ParseUint(hex[2:3], 16, 8)
		if err != nil {
			return 0, err
		}
		// Expand single digit to double digit
		r = r*16 + r
		g = g*16 + g
		b = b*16 + b
		return ArgbFromRgb(uint8(r), uint8(g), uint8(b)), nil

	case 6:
		// RRGGBB format
		rgb, err := strconv.ParseUint(hex, 16, 24)
		if err != nil {
			return 0, err
		}
		return 0xFF000000 | uint32(rgb), nil

	case 8:
		// AARRGGBB format
		argb, err := strconv.ParseUint(hex, 16, 32)
		if err != nil {
			return 0, err
		}
		return uint32(argb), nil

	default:
		return 0, fmt.Errorf("invalid hex color format: %s", hex)
	}
}
