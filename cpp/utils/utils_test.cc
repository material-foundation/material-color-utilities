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

#include "material_color_utilities/cpp/utils/utils.h"

#include <cstdint>

#include "testing/base/public/gmock.h"
#include "testing/base/public/gunit.h"

namespace material_color_utilities {

namespace {

using testing::DoubleNear;

constexpr double kMatrix[3][3] = {
    {1, 2, 3},
    {-4, 5, -6},
    {-7, -8, -9},
};

TEST(UtilsTest, Signum) {
  EXPECT_EQ(Signum(0.001), 1);
  EXPECT_EQ(Signum(3.0), 1);
  EXPECT_EQ(Signum(100.0), 1);
  EXPECT_EQ(Signum(-0.002), -1);
  EXPECT_EQ(Signum(-4.0), -1);
  EXPECT_EQ(Signum(-101.0), -1);
  EXPECT_EQ(Signum(0.0), 0);
}

TEST(UtilsTest, RotationIsPositiveForCounterclockwise) {
  EXPECT_EQ(RotationDirection(0.0, 30.0), 1.0);
  EXPECT_EQ(RotationDirection(0.0, 60.0), 1.0);
  EXPECT_EQ(RotationDirection(0.0, 150.0), 1.0);
  EXPECT_EQ(RotationDirection(90.0, 240.0), 1.0);
  EXPECT_EQ(RotationDirection(300.0, 30.0), 1.0);
  EXPECT_EQ(RotationDirection(270.0, 60.0), 1.0);
  EXPECT_EQ(RotationDirection(360.0 * 2, 15.0), 1.0);
  EXPECT_EQ(RotationDirection(360.0 * 3 + 15.0, -360.0 * 4 + 30.0), 1.0);
}

TEST(UtilsTest, RotationIsNegativeForClockwise) {
  EXPECT_EQ(RotationDirection(30.0, 0.0), -1.0);
  EXPECT_EQ(RotationDirection(60.0, 0.0), -1.0);
  EXPECT_EQ(RotationDirection(150.0, 0.0), -1.0);
  EXPECT_EQ(RotationDirection(240.0, 90.0), -1.0);
  EXPECT_EQ(RotationDirection(30.0, 300.0), -1.0);
  EXPECT_EQ(RotationDirection(60.0, 270.0), -1.0);
  EXPECT_EQ(RotationDirection(15.0, -360.0 * 2), -1.0);
  EXPECT_EQ(RotationDirection(-360.0 * 4 + 270.0, 360.0 * 5 + 180.0), -1.0);
}

TEST(UtilsTest, AngleDifference) {
  EXPECT_EQ(DiffDegrees(0.0, 30.0), 30.0);
  EXPECT_EQ(DiffDegrees(0.0, 60.0), 60.0);
  EXPECT_EQ(DiffDegrees(0.0, 150.0), 150.0);
  EXPECT_EQ(DiffDegrees(90.0, 240.0), 150.0);
  EXPECT_EQ(DiffDegrees(300.0, 30.0), 90.0);
  EXPECT_EQ(DiffDegrees(270.0, 60.0), 150.0);

  EXPECT_EQ(DiffDegrees(30.0, 0.0), 30.0);
  EXPECT_EQ(DiffDegrees(60.0, 0.0), 60.0);
  EXPECT_EQ(DiffDegrees(150.0, 0.0), 150.0);
  EXPECT_EQ(DiffDegrees(240.0, 90.0), 150.0);
  EXPECT_EQ(DiffDegrees(30.0, 300.0), 90.0);
  EXPECT_EQ(DiffDegrees(60.0, 270.0), 150.0);
}

TEST(UtilsTest, AngleSanitation) {
  EXPECT_EQ(SanitizeDegreesInt(30), 30);
  EXPECT_EQ(SanitizeDegreesInt(240), 240);
  EXPECT_EQ(SanitizeDegreesInt(360), 0);
  EXPECT_EQ(SanitizeDegreesInt(-30), 330);
  EXPECT_EQ(SanitizeDegreesInt(-750), 330);
  EXPECT_EQ(SanitizeDegreesInt(-54321), 39);

  EXPECT_THAT(SanitizeDegreesDouble(30.0), DoubleNear(30.0, 1e-4));
  EXPECT_THAT(SanitizeDegreesDouble(240.0), DoubleNear(240.0, 1e-4));
  EXPECT_THAT(SanitizeDegreesDouble(360.0), DoubleNear(0.0, 1e-4));
  EXPECT_THAT(SanitizeDegreesDouble(-30.0), DoubleNear(330.0, 1e-4));
  EXPECT_THAT(SanitizeDegreesDouble(-750.0), DoubleNear(330.0, 1e-4));
  EXPECT_THAT(SanitizeDegreesDouble(-54321.0), DoubleNear(39.0, 1e-4));
  EXPECT_THAT(SanitizeDegreesDouble(360.125), DoubleNear(0.125, 1e-4));
  EXPECT_THAT(SanitizeDegreesDouble(-11111.11), DoubleNear(48.89, 1e-4));
}

TEST(UtilsTest, MatrixMultiply) {
  Vec3 vector_one = MatrixMultiply({1, 3, 5}, kMatrix);
  EXPECT_THAT(vector_one.a, DoubleNear(22, 1e-4));
  EXPECT_THAT(vector_one.b, DoubleNear(-19, 1e-4));
  EXPECT_THAT(vector_one.c, DoubleNear(-76, 1e-4));

  Vec3 vector_two = MatrixMultiply({-11.1, 22.2, -33.3}, kMatrix);
  EXPECT_THAT(vector_two.a, DoubleNear(-66.6, 1e-4));
  EXPECT_THAT(vector_two.b, DoubleNear(355.2, 1e-4));
  EXPECT_THAT(vector_two.c, DoubleNear(199.8, 1e-4));
}

TEST(UtilsTest, AlphaFromInt) {
  EXPECT_EQ(AlphaFromInt(0xff123456), 0xff);
  EXPECT_EQ(AlphaFromInt(0xffabcdef), 0xff);
}

TEST(UtilsTest, RedFromInt) {
  EXPECT_EQ(RedFromInt(0xff123456), 0x12);
  EXPECT_EQ(RedFromInt(0xffabcdef), 0xab);
}

TEST(UtilsTest, GreenFromInt) {
  EXPECT_EQ(GreenFromInt(0xff123456), 0x34);
  EXPECT_EQ(GreenFromInt(0xffabcdef), 0xcd);
}

TEST(UtilsTest, BlueFromInt) {
  EXPECT_EQ(BlueFromInt(0xff123456), 0x56);
  EXPECT_EQ(BlueFromInt(0xffabcdef), 0xef);
}

TEST(UtilsTest, Opaqueness) {
  EXPECT_TRUE(IsOpaque(0xff123456));
  EXPECT_FALSE(IsOpaque(0xf0123456));
  EXPECT_FALSE(IsOpaque(0x00123456));
}

TEST(UtilsTest, LinearizedComponents) {
  EXPECT_THAT(Linearized(0), DoubleNear(0.0, 1e-4));
  EXPECT_THAT(Linearized(1), DoubleNear(0.0303527, 1e-4));
  EXPECT_THAT(Linearized(2), DoubleNear(0.0607054, 1e-4));
  EXPECT_THAT(Linearized(8), DoubleNear(0.242822, 1e-4));
  EXPECT_THAT(Linearized(9), DoubleNear(0.273174, 1e-4));
  EXPECT_THAT(Linearized(16), DoubleNear(0.518152, 1e-4));
  EXPECT_THAT(Linearized(32), DoubleNear(1.44438, 1e-4));
  EXPECT_THAT(Linearized(64), DoubleNear(5.12695, 1e-4));
  EXPECT_THAT(Linearized(128), DoubleNear(21.5861, 1e-4));
  EXPECT_THAT(Linearized(255), DoubleNear(100.0, 1e-4));
}

TEST(UtilsTest, DelinearizedComponents) {
  EXPECT_EQ(Delinearized(0.0), 0);
  EXPECT_EQ(Delinearized(0.0303527), 1);
  EXPECT_EQ(Delinearized(0.0607054), 2);
  EXPECT_EQ(Delinearized(0.242822), 8);
  EXPECT_EQ(Delinearized(0.273174), 9);
  EXPECT_EQ(Delinearized(0.518152), 16);
  EXPECT_EQ(Delinearized(1.44438), 32);
  EXPECT_EQ(Delinearized(5.12695), 64);
  EXPECT_EQ(Delinearized(21.5861), 128);
  EXPECT_EQ(Delinearized(100.0), 255);

  EXPECT_EQ(Delinearized(25.0), 137);
  EXPECT_EQ(Delinearized(50.0), 188);
  EXPECT_EQ(Delinearized(75.0), 225);

  // Delinearized clamps out-of-range inputs.
  EXPECT_EQ(Delinearized(-1.0), 0);
  EXPECT_EQ(Delinearized(-10000.0), 0);
  EXPECT_EQ(Delinearized(101.0), 255);
  EXPECT_EQ(Delinearized(10000.0), 255);
}

TEST(UtilsTest, DelinearizedIsLeftInverseOfLinearized) {
  EXPECT_EQ(Delinearized(Linearized(0)), 0);
  EXPECT_EQ(Delinearized(Linearized(1)), 1);
  EXPECT_EQ(Delinearized(Linearized(2)), 2);
  EXPECT_EQ(Delinearized(Linearized(8)), 8);
  EXPECT_EQ(Delinearized(Linearized(9)), 9);
  EXPECT_EQ(Delinearized(Linearized(16)), 16);
  EXPECT_EQ(Delinearized(Linearized(32)), 32);
  EXPECT_EQ(Delinearized(Linearized(64)), 64);
  EXPECT_EQ(Delinearized(Linearized(128)), 128);
  EXPECT_EQ(Delinearized(Linearized(255)), 255);
}

TEST(UtilsTest, ArgbFromLinrgb) {
  EXPECT_EQ(static_cast<uint32_t>(ArgbFromLinrgb({25.0, 50.0, 75.0})),
            0xff89bce1);
  EXPECT_EQ(static_cast<uint32_t>(ArgbFromLinrgb({0.03, 0.06, 0.12})),
            0xff010204);
}

TEST(UtilsTest, LstarFromArgb) {
  EXPECT_THAT(LstarFromArgb(0xff89bce1), DoubleNear(74.011, 1e-4));
  EXPECT_THAT(LstarFromArgb(0xff010204), DoubleNear(0.529651, 1e-4));
}

TEST(UtilsTest, HexFromArgb) {
  EXPECT_EQ(HexFromArgb(0xff89bce1), "ff89bce1");
  EXPECT_EQ(HexFromArgb(0xff010204), "ff010204");
}

TEST(UtilsTest, YFromLstar) {
  EXPECT_THAT(YFromLstar(0.0), DoubleNear(0.0, 1e-4));
  EXPECT_THAT(YFromLstar(1.0), DoubleNear(0.110706, 1e-4));
  EXPECT_THAT(YFromLstar(2.0), DoubleNear(0.221411, 1e-4));
  EXPECT_THAT(YFromLstar(8.0), DoubleNear(0.885645, 1e-4));
  EXPECT_THAT(YFromLstar(50.0), DoubleNear(18.4187, 1e-4));
  EXPECT_THAT(YFromLstar(100.0), DoubleNear(100.0, 1e-4));
}

TEST(UtilsTest, IntFromLstar) {
  // Given an L* brightness value in [0, 100], IntFromLstar returns a greyscale
  // color in ARGB format with that brightness.
  // For L* outside the domain [0, 100], returns black or white.

  EXPECT_EQ(static_cast<uint32_t>(IntFromLstar(0.0)), 0xff000000);
  EXPECT_EQ(static_cast<uint32_t>(IntFromLstar(0.25)), 0xff010101);
  EXPECT_EQ(static_cast<uint32_t>(IntFromLstar(0.5)), 0xff020202);
  EXPECT_EQ(static_cast<uint32_t>(IntFromLstar(1.0)), 0xff040404);
  EXPECT_EQ(static_cast<uint32_t>(IntFromLstar(2.0)), 0xff070707);
  EXPECT_EQ(static_cast<uint32_t>(IntFromLstar(4.0)), 0xff0e0e0e);
  EXPECT_EQ(static_cast<uint32_t>(IntFromLstar(8.0)), 0xff181818);
  EXPECT_EQ(static_cast<uint32_t>(IntFromLstar(25.0)), 0xff3b3b3b);
  EXPECT_EQ(static_cast<uint32_t>(IntFromLstar(50.0)), 0xff777777);
  EXPECT_EQ(static_cast<uint32_t>(IntFromLstar(75.0)), 0xffb9b9b9);
  EXPECT_EQ(static_cast<uint32_t>(IntFromLstar(99.0)), 0xfffcfcfc);
  EXPECT_EQ(static_cast<uint32_t>(IntFromLstar(100.0)), 0xffffffff);

  EXPECT_EQ(static_cast<uint32_t>(IntFromLstar(-1.0)), 0xff000000);
  EXPECT_EQ(static_cast<uint32_t>(IntFromLstar(-2.0)), 0xff000000);
  EXPECT_EQ(static_cast<uint32_t>(IntFromLstar(-3.0)), 0xff000000);
  EXPECT_EQ(static_cast<uint32_t>(IntFromLstar(-9999999.0)), 0xff000000);

  EXPECT_EQ(static_cast<uint32_t>(IntFromLstar(101.0)), 0xffffffff);
  EXPECT_EQ(static_cast<uint32_t>(IntFromLstar(111.0)), 0xffffffff);
  EXPECT_EQ(static_cast<uint32_t>(IntFromLstar(9999999.0)), 0xffffffff);
}

TEST(UtilsTest, LstarArgbRoundtripProperty) {
  // Confirms that L* -> ARGB -> L* preserves original value
  // (taking ARGB rounding into consideration).
  EXPECT_THAT(LstarFromArgb(IntFromLstar(0.0)), DoubleNear(0.0, 1.0));
  EXPECT_THAT(LstarFromArgb(IntFromLstar(1.0)), DoubleNear(1.0, 1.0));
  EXPECT_THAT(LstarFromArgb(IntFromLstar(2.0)), DoubleNear(2.0, 1.0));
  EXPECT_THAT(LstarFromArgb(IntFromLstar(8.0)), DoubleNear(8.0, 1.0));
  EXPECT_THAT(LstarFromArgb(IntFromLstar(25.0)), DoubleNear(25.0, 1.0));
  EXPECT_THAT(LstarFromArgb(IntFromLstar(50.0)), DoubleNear(50.0, 1.0));
  EXPECT_THAT(LstarFromArgb(IntFromLstar(75.0)), DoubleNear(75.0, 1.0));
  EXPECT_THAT(LstarFromArgb(IntFromLstar(99.0)), DoubleNear(99.0, 1.0));
  EXPECT_THAT(LstarFromArgb(IntFromLstar(100.0)), DoubleNear(100.0, 1.0));
}

TEST(UtilsTest, ArgbLstarRoundtripProperty) {
  // Confirms that ARGB -> L* -> ARGB preserves original value
  // for greyscale colors.
  EXPECT_EQ(static_cast<uint32_t>(IntFromLstar(LstarFromArgb(0xff000000))),
            0xff000000);
  EXPECT_EQ(static_cast<uint32_t>(IntFromLstar(LstarFromArgb(0xff010101))),
            0xff010101);
  EXPECT_EQ(static_cast<uint32_t>(IntFromLstar(LstarFromArgb(0xff020202))),
            0xff020202);
  EXPECT_EQ(static_cast<uint32_t>(IntFromLstar(LstarFromArgb(0xff111111))),
            0xff111111);
  EXPECT_EQ(static_cast<uint32_t>(IntFromLstar(LstarFromArgb(0xff333333))),
            0xff333333);
  EXPECT_EQ(static_cast<uint32_t>(IntFromLstar(LstarFromArgb(0xff777777))),
            0xff777777);
  EXPECT_EQ(static_cast<uint32_t>(IntFromLstar(LstarFromArgb(0xffbbbbbb))),
            0xffbbbbbb);
  EXPECT_EQ(static_cast<uint32_t>(IntFromLstar(LstarFromArgb(0xfffefefe))),
            0xfffefefe);
  EXPECT_EQ(static_cast<uint32_t>(IntFromLstar(LstarFromArgb(0xffffffff))),
            0xffffffff);
}

}  // namespace
}  // namespace material_color_utilities
