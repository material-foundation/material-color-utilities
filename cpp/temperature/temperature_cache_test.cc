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

#include "cpp/temperature/temperature_cache.h"

#include <vector>

#include "testing/base/public/gunit.h"
#include "cpp/cam/hct.h"

namespace material_color_utilities {

namespace {

TEST(TemperatureCacheTest, RawTemperature) {
  Hct blue_hct(0xff0000ff);
  double blue_temp = TemperatureCache::RawTemperature(blue_hct);
  EXPECT_NEAR(-1.393, blue_temp, 0.001);

  Hct red_hct(0xffff0000);
  double red_temp = TemperatureCache::RawTemperature(red_hct);
  EXPECT_NEAR(2.351, red_temp, 0.001);

  Hct green_hct(0xff00ff00);
  double green_temp = TemperatureCache::RawTemperature(green_hct);
  EXPECT_NEAR(-0.267, green_temp, 0.001);

  Hct white_hct(0xffffffff);
  double white_temp = TemperatureCache::RawTemperature(white_hct);
  EXPECT_NEAR(-0.5, white_temp, 0.001);

  Hct black_hct(0xff000000);
  double black_temp = TemperatureCache::RawTemperature(black_hct);
  EXPECT_NEAR(-0.5, black_temp, 0.001);
}

TEST(TemperatureCacheTest, Complement) {
  unsigned int blue_complement =
      TemperatureCache(Hct(0xff0000ff)).GetComplement().ToInt();
  EXPECT_EQ(0xff9d0002, blue_complement);

  unsigned int red_complement =
      TemperatureCache(Hct(0xffff0000)).GetComplement().ToInt();
  EXPECT_EQ(0xff007bfc, red_complement);

  unsigned int green_complement =
      TemperatureCache(Hct(0xff00ff00)).GetComplement().ToInt();
  EXPECT_EQ(0xffffd2c9, green_complement);

  unsigned int white_complement =
      TemperatureCache(Hct(0xffffffff)).GetComplement().ToInt();
  EXPECT_EQ(0xffffffff, white_complement);

  unsigned int black_complement =
      TemperatureCache(Hct(0xff000000)).GetComplement().ToInt();
  EXPECT_EQ(0xff000000, black_complement);
}

TEST(TemperatureCacheTest, Analogous) {
  std::vector<Hct> blue_analogous =
      TemperatureCache(Hct(0xff0000ff)).GetAnalogousColors();
  EXPECT_EQ(0xff00590c, blue_analogous.at(0).ToInt());
  EXPECT_EQ(0xff00564e, blue_analogous.at(1).ToInt());
  EXPECT_EQ(0xff0000ff, blue_analogous.at(2).ToInt());
  EXPECT_EQ(0xff6700cc, blue_analogous.at(3).ToInt());
  EXPECT_EQ(0xff81009f, blue_analogous.at(4).ToInt());

  std::vector<Hct> red_analogous =
      TemperatureCache(Hct(0xffff0000)).GetAnalogousColors();
  EXPECT_EQ(0xfff60082, red_analogous.at(0).ToInt());
  EXPECT_EQ(0xfffc004c, red_analogous.at(1).ToInt());
  EXPECT_EQ(0xffff0000, red_analogous.at(2).ToInt());
  EXPECT_EQ(0xffd95500, red_analogous.at(3).ToInt());
  EXPECT_EQ(0xffaf7200, red_analogous.at(4).ToInt());

  std::vector<Hct> green_analogous =
      TemperatureCache(Hct(0xff00ff00)).GetAnalogousColors();
  EXPECT_EQ(0xffcee900, green_analogous.at(0).ToInt());
  EXPECT_EQ(0xff92f500, green_analogous.at(1).ToInt());
  EXPECT_EQ(0xff00ff00, green_analogous.at(2).ToInt());
  EXPECT_EQ(0xff00fd6f, green_analogous.at(3).ToInt());
  EXPECT_EQ(0xff00fab3, green_analogous.at(4).ToInt());

  std::vector<Hct> black_analogous =
      TemperatureCache(Hct(0xff000000)).GetAnalogousColors();
  EXPECT_EQ(0xff000000, black_analogous.at(0).ToInt());
  EXPECT_EQ(0xff000000, black_analogous.at(1).ToInt());
  EXPECT_EQ(0xff000000, black_analogous.at(2).ToInt());
  EXPECT_EQ(0xff000000, black_analogous.at(3).ToInt());
  EXPECT_EQ(0xff000000, black_analogous.at(4).ToInt());

  std::vector<Hct> white_analogous =
      TemperatureCache(Hct(0xffffffff)).GetAnalogousColors();
  EXPECT_EQ(0xffffffff, white_analogous.at(0).ToInt());
  EXPECT_EQ(0xffffffff, white_analogous.at(1).ToInt());
  EXPECT_EQ(0xffffffff, white_analogous.at(2).ToInt());
  EXPECT_EQ(0xffffffff, white_analogous.at(3).ToInt());
  EXPECT_EQ(0xffffffff, white_analogous.at(4).ToInt());
}

}  // namespace
}  // namespace material_color_utilities
