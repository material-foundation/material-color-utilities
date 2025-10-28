cmake_minimum_required(VERSION 3.15)
project(MyProject LANGUAGES CXX)

# add_executable(material-colors src/main.cc)
add_library(material-colors STATIC src/mylib/mylib.cc)

target_link_libraries(material-colors PUBLIC material_color_utilities_lib)

set_property(TARGET material-colors PROPERTY CXX_STANDARD 17)
set_property(TARGET material-colors PROPERTY CXX_STANDARD_REQUIRED ON)
set_target_properties(material-colors PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY ../../libs
)

add_library(material_color_utilities_lib STATIC
    src/material-color-utilities/cpp/cam/hct.cc
    src/material-color-utilities/cpp/cam/hct_solver.cc
    src/material-color-utilities/cpp/cam/cam.cc
    src/material-color-utilities/cpp/cam/viewing_conditions.cc
    src/material-color-utilities/cpp/utils/utils.cc
)
set_target_properties(material_color_utilities_lib PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY ../../libs
)

target_include_directories(material-colors PRIVATE
    src/material-color-utilities
    src
)

target_include_directories(material_color_utilities_lib PRIVATE
    src/material-color-utilities
)