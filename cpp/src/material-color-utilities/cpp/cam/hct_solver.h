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

#ifndef CPP_CAM_HCT_SOLVER_H_
#define CPP_CAM_HCT_SOLVER_H_

#include "cpp/cam/cam.h"

namespace material_color_utilities {

Argb SolveToInt(double hue_degrees, double chroma, double lstar);
Cam SolveToCam(double hue_degrees, double chroma, double lstar);

}  // namespace material_color_utilities
#endif  // CPP_CAM_HCT_SOLVER_H_
