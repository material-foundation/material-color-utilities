#include "material-color-utilities/cpp/utils/utils.h"
#include "material-color-utilities/cpp/cam/hct.h"
#include "mylib.h"

Rgb BuildRgb(int red, int green, int blue) {
    Rgb rgb;
    rgb.Red = red;
    rgb.Green = green;
    rgb.Blue = blue;
    return rgb;
}

Hct BuildHct(double hue, double chroma, double tone) {
    Hct hct;
    hct.Hue = hue;
    hct.Chroma = chroma;
    hct.Tone = tone;
    return hct;
}

Hct RgbToHct(Rgb rgb) {
    material_color_utilities::Argb argb =
        material_color_utilities::ArgbFromRgb(rgb.Red, rgb.Green, rgb.Blue);
    material_color_utilities::Hct hct = 
        material_color_utilities::Hct(argb);
    Hct res;
    res.Hue = hct.get_hue();
    res.Chroma = hct.get_chroma();
    res.Tone = hct.get_tone();
    return res;
}

Rgb HctToRgb(Hct hct) {
    material_color_utilities::Hct a =
        material_color_utilities::Hct(hct.Hue, hct.Chroma, hct.Tone);
    material_color_utilities::Argb argb = a.ToInt();
    int red = material_color_utilities::RedFromInt(argb);
    int green = material_color_utilities::GreenFromInt(argb);
    int blue = material_color_utilities::BlueFromInt(argb);
    Rgb res;
    res.Red = red;
    res.Green = green;
    res.Blue = blue;
    return res;
}

