#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
    int Red;
    int Green;
    int Blue;
} Rgb;

typedef struct {
    double Hue;
    double Chroma;
    double Tone;
} Hct;

int GetPrimary(int, int, int);

Rgb BuildRgb(int, int, int);
Hct BuildHct(double, double, double);
Hct RgbToHct(Rgb);
Rgb HctToRgb(Hct);

#ifdef __cplusplus
}
#endif