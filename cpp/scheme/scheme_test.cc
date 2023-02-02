/*
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

#include "cpp/scheme/scheme.h"

#include "testing/base/public/gunit.h"
#include "cpp/utils/utils.h"

namespace material_color_utilities {

namespace {

TEST(SchemeTest, SurfaceTones) {
  Argb color = 0xff0000ff;
  Scheme dark = MaterialDarkColorScheme(color);
  EXPECT_NEAR(LstarFromArgb(dark.surface), 10.0, 0.5);

  Scheme light = MaterialLightColorScheme(color);
  EXPECT_NEAR(LstarFromArgb(light.surface), 99.0, 0.5);
}

TEST(SchemeTest, BlueLightScheme) {
  Scheme scheme = MaterialLightColorScheme(0xff0000ff);
  EXPECT_EQ(HexFromArgb(scheme.primary), "ff343dff");
}

TEST(SchemeTest, BlueDarkScheme) {
  Scheme scheme = MaterialDarkColorScheme(0xff0000ff);
  EXPECT_EQ(HexFromArgb(scheme.primary), "ffbec2ff");
}

TEST(SchemeTest, ThirdPartyLightScheme) {
  Scheme scheme = MaterialLightColorScheme(0xff6750A4);
  EXPECT_EQ(HexFromArgb(scheme.primary), "ff6750a4");
  EXPECT_EQ(HexFromArgb(scheme.secondary), "ff625b71");
  EXPECT_EQ(HexFromArgb(scheme.tertiary), "ff7e5260");
  EXPECT_EQ(HexFromArgb(scheme.surface), "fffffbff");
  EXPECT_EQ(HexFromArgb(scheme.on_surface), "ff1c1b1e");
}

TEST(SchemeTest, ThirdPartyDarkScheme) {
  Scheme scheme = MaterialDarkColorScheme(0xff6750A4);
  EXPECT_EQ(HexFromArgb(scheme.primary), "ffcfbcff");
  EXPECT_EQ(HexFromArgb(scheme.secondary), "ffcbc2db");
  EXPECT_EQ(HexFromArgb(scheme.tertiary), "ffefb8c8");
  EXPECT_EQ(HexFromArgb(scheme.surface), "ff1c1b1e");
  EXPECT_EQ(HexFromArgb(scheme.on_surface), "ffe6e1e6");
}

TEST(SchemeTest, LightSchemeFromHighChromaColor) {
  Scheme scheme = MaterialLightColorScheme(0xfffa2bec);
  EXPECT_EQ(HexFromArgb(scheme.primary), "ffab00a2");
  EXPECT_EQ(HexFromArgb(scheme.on_primary), "ffffffff");
  EXPECT_EQ(HexFromArgb(scheme.primary_container), "ffffd7f3");
  EXPECT_EQ(HexFromArgb(scheme.on_primary_container), "ff390035");
  EXPECT_EQ(HexFromArgb(scheme.secondary), "ff6e5868");
  EXPECT_EQ(HexFromArgb(scheme.on_secondary), "ffffffff");
  EXPECT_EQ(HexFromArgb(scheme.secondary_container), "fff8daee");
  EXPECT_EQ(HexFromArgb(scheme.on_secondary_container), "ff271624");
  EXPECT_EQ(HexFromArgb(scheme.tertiary), "ff815343");
  EXPECT_EQ(HexFromArgb(scheme.on_tertiary), "ffffffff");
  EXPECT_EQ(HexFromArgb(scheme.tertiary_container), "ffffdbd0");
  EXPECT_EQ(HexFromArgb(scheme.on_tertiary_container), "ff321207");
  EXPECT_EQ(HexFromArgb(scheme.error), "ffba1a1a");
  EXPECT_EQ(HexFromArgb(scheme.on_error), "ffffffff");
  EXPECT_EQ(HexFromArgb(scheme.error_container), "ffffdad6");
  EXPECT_EQ(HexFromArgb(scheme.on_error_container), "ff410002");
  EXPECT_EQ(HexFromArgb(scheme.background), "fffffbff");
  EXPECT_EQ(HexFromArgb(scheme.on_background), "ff1f1a1d");
  EXPECT_EQ(HexFromArgb(scheme.surface), "fffffbff");
  EXPECT_EQ(HexFromArgb(scheme.on_surface), "ff1f1a1d");
  EXPECT_EQ(HexFromArgb(scheme.surface_variant), "ffeedee7");
  EXPECT_EQ(HexFromArgb(scheme.on_surface_variant), "ff4e444b");
  EXPECT_EQ(HexFromArgb(scheme.outline), "ff80747b");
  EXPECT_EQ(HexFromArgb(scheme.outline_variant), "ffd2c2cb");
  EXPECT_EQ(HexFromArgb(scheme.shadow), "ff000000");
  EXPECT_EQ(HexFromArgb(scheme.scrim), "ff000000");
  EXPECT_EQ(HexFromArgb(scheme.inverse_surface), "ff342f32");
  EXPECT_EQ(HexFromArgb(scheme.inverse_on_surface), "fff8eef2");
  EXPECT_EQ(HexFromArgb(scheme.inverse_primary), "ffffabee");
}

TEST(SchemeTest, DarkSchemeFromHighChromaColor) {
  Scheme scheme = MaterialDarkColorScheme(0xfffa2bec);
  EXPECT_EQ(HexFromArgb(scheme.primary), "ffffabee");
  EXPECT_EQ(HexFromArgb(scheme.on_primary), "ff5c0057");
  EXPECT_EQ(HexFromArgb(scheme.primary_container), "ff83007b");
  EXPECT_EQ(HexFromArgb(scheme.on_primary_container), "ffffd7f3");
  EXPECT_EQ(HexFromArgb(scheme.secondary), "ffdbbed1");
  EXPECT_EQ(HexFromArgb(scheme.on_secondary), "ff3e2a39");
  EXPECT_EQ(HexFromArgb(scheme.secondary_container), "ff554050");
  EXPECT_EQ(HexFromArgb(scheme.on_secondary_container), "fff8daee");
  EXPECT_EQ(HexFromArgb(scheme.tertiary), "fff5b9a5");
  EXPECT_EQ(HexFromArgb(scheme.on_tertiary), "ff4c2619");
  EXPECT_EQ(HexFromArgb(scheme.tertiary_container), "ff663c2d");
  EXPECT_EQ(HexFromArgb(scheme.on_tertiary_container), "ffffdbd0");
  EXPECT_EQ(HexFromArgb(scheme.error), "ffffb4ab");
  EXPECT_EQ(HexFromArgb(scheme.on_error), "ff690005");
  EXPECT_EQ(HexFromArgb(scheme.error_container), "ff93000a");
  EXPECT_EQ(HexFromArgb(scheme.on_error_container), "ffffb4ab");
  EXPECT_EQ(HexFromArgb(scheme.background), "ff1f1a1d");
  EXPECT_EQ(HexFromArgb(scheme.on_background), "ffeae0e4");
  EXPECT_EQ(HexFromArgb(scheme.surface), "ff1f1a1d");
  EXPECT_EQ(HexFromArgb(scheme.on_surface), "ffeae0e4");
  EXPECT_EQ(HexFromArgb(scheme.surface_variant), "ff4e444b");
  EXPECT_EQ(HexFromArgb(scheme.on_surface_variant), "ffd2c2cb");
  EXPECT_EQ(HexFromArgb(scheme.outline), "ff9a8d95");
  EXPECT_EQ(HexFromArgb(scheme.outline_variant), "ff4e444b");
  EXPECT_EQ(HexFromArgb(scheme.shadow), "ff000000");
  EXPECT_EQ(HexFromArgb(scheme.scrim), "ff000000");
  EXPECT_EQ(HexFromArgb(scheme.inverse_surface), "ffeae0e4");
  EXPECT_EQ(HexFromArgb(scheme.inverse_on_surface), "ff342f32");
  EXPECT_EQ(HexFromArgb(scheme.inverse_primary), "ffab00a2");
}

TEST(SchemeTest, LightContentSchemeFromHighChromaColor) {
  Scheme scheme = MaterialLightContentColorScheme(0xfffa2bec);
  EXPECT_EQ(HexFromArgb(scheme.primary), "ffab00a2");
  EXPECT_EQ(HexFromArgb(scheme.on_primary), "ffffffff");
  EXPECT_EQ(HexFromArgb(scheme.primary_container), "ffffd7f3");
  EXPECT_EQ(HexFromArgb(scheme.on_primary_container), "ff390035");
  EXPECT_EQ(HexFromArgb(scheme.secondary), "ff7f4e75");
  EXPECT_EQ(HexFromArgb(scheme.on_secondary), "ffffffff");
  EXPECT_EQ(HexFromArgb(scheme.secondary_container), "ffffd7f3");
  EXPECT_EQ(HexFromArgb(scheme.on_secondary_container), "ff330b2f");
  EXPECT_EQ(HexFromArgb(scheme.tertiary), "ff9c4323");
  EXPECT_EQ(HexFromArgb(scheme.on_tertiary), "ffffffff");
  EXPECT_EQ(HexFromArgb(scheme.tertiary_container), "ffffdbd0");
  EXPECT_EQ(HexFromArgb(scheme.on_tertiary_container), "ff390c00");
  EXPECT_EQ(HexFromArgb(scheme.error), "ffba1a1a");
  EXPECT_EQ(HexFromArgb(scheme.on_error), "ffffffff");
  EXPECT_EQ(HexFromArgb(scheme.error_container), "ffffdad6");
  EXPECT_EQ(HexFromArgb(scheme.on_error_container), "ff410002");
  EXPECT_EQ(HexFromArgb(scheme.background), "fffffbff");
  EXPECT_EQ(HexFromArgb(scheme.on_background), "ff1f1a1d");
  EXPECT_EQ(HexFromArgb(scheme.surface), "fffffbff");
  EXPECT_EQ(HexFromArgb(scheme.on_surface), "ff1f1a1d");
  EXPECT_EQ(HexFromArgb(scheme.surface_variant), "ffeedee7");
  EXPECT_EQ(HexFromArgb(scheme.on_surface_variant), "ff4e444b");
  EXPECT_EQ(HexFromArgb(scheme.outline), "ff80747b");
  EXPECT_EQ(HexFromArgb(scheme.outline_variant), "ffd2c2cb");
  EXPECT_EQ(HexFromArgb(scheme.shadow), "ff000000");
  EXPECT_EQ(HexFromArgb(scheme.scrim), "ff000000");
  EXPECT_EQ(HexFromArgb(scheme.inverse_surface), "ff342f32");
  EXPECT_EQ(HexFromArgb(scheme.inverse_on_surface), "fff8eef2");
  EXPECT_EQ(HexFromArgb(scheme.inverse_primary), "ffffabee");
}

TEST(SchemeTest, DarkContentSchemeFromHighChromaColor) {
  Scheme scheme = MaterialDarkContentColorScheme(0xfffa2bec);
  EXPECT_EQ(HexFromArgb(scheme.primary), "ffffabee");
  EXPECT_EQ(HexFromArgb(scheme.on_primary), "ff5c0057");
  EXPECT_EQ(HexFromArgb(scheme.primary_container), "ff83007b");
  EXPECT_EQ(HexFromArgb(scheme.on_primary_container), "ffffd7f3");
  EXPECT_EQ(HexFromArgb(scheme.secondary), "fff0b4e1");
  EXPECT_EQ(HexFromArgb(scheme.on_secondary), "ff4b2145");
  EXPECT_EQ(HexFromArgb(scheme.secondary_container), "ff64375c");
  EXPECT_EQ(HexFromArgb(scheme.on_secondary_container), "ffffd7f3");
  EXPECT_EQ(HexFromArgb(scheme.tertiary), "ffffb59c");
  EXPECT_EQ(HexFromArgb(scheme.on_tertiary), "ff5c1900");
  EXPECT_EQ(HexFromArgb(scheme.tertiary_container), "ff7d2c0d");
  EXPECT_EQ(HexFromArgb(scheme.on_tertiary_container), "ffffdbd0");
  EXPECT_EQ(HexFromArgb(scheme.error), "ffffb4ab");
  EXPECT_EQ(HexFromArgb(scheme.on_error), "ff690005");
  EXPECT_EQ(HexFromArgb(scheme.error_container), "ff93000a");
  EXPECT_EQ(HexFromArgb(scheme.on_error_container), "ffffb4ab");
  EXPECT_EQ(HexFromArgb(scheme.background), "ff1f1a1d");
  EXPECT_EQ(HexFromArgb(scheme.on_background), "ffeae0e4");
  EXPECT_EQ(HexFromArgb(scheme.surface), "ff1f1a1d");
  EXPECT_EQ(HexFromArgb(scheme.on_surface), "ffeae0e4");
  EXPECT_EQ(HexFromArgb(scheme.surface_variant), "ff4e444b");
  EXPECT_EQ(HexFromArgb(scheme.on_surface_variant), "ffd2c2cb");
  EXPECT_EQ(HexFromArgb(scheme.outline), "ff9a8d95");
  EXPECT_EQ(HexFromArgb(scheme.outline_variant), "ff4e444b");
  EXPECT_EQ(HexFromArgb(scheme.shadow), "ff000000");
  EXPECT_EQ(HexFromArgb(scheme.scrim), "ff000000");
  EXPECT_EQ(HexFromArgb(scheme.inverse_surface), "ffeae0e4");
  EXPECT_EQ(HexFromArgb(scheme.inverse_on_surface), "ff342f32");
  EXPECT_EQ(HexFromArgb(scheme.inverse_primary), "ffab00a2");
}

}  // namespace
}  // namespace material_color_utilities
