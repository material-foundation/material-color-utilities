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

import 'package:material_color_utilities/blend/blend.dart';
import 'package:test/test.dart';

const red = 0xffff0000;
const blue = 0xff0000ff;

void main() {
  test('blendRedAndBlue', () async {
    final answer = Blend.cam16ucs(red, blue, 0.8);
    expect(answer, equals(0xFF6440B4));
  });
}
