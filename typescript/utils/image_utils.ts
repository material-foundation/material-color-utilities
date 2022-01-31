import { QuantizerCelebi } from "../quantize/quantizer_celebi";
import { Score } from "../score/score";
import { argbFromRgb } from "./color_utils";
import { hexFromArgb } from "./string_utils";

/**
 * Get the seed from an image.
 *
 * @param image The image src
 * @return Seed color
 */
export async function seedFromImage(image: ArrayBuffer | string) {
  const imageBuffer =
    typeof image === "string"
      ? await (await fetch(image)).arrayBuffer()
      : image;

  const imageBlob = new Blob([imageBuffer], { type: "image/png" });
  const imageUrl = URL.createObjectURL(imageBlob);

  // Convert Image data to Pixel Array
  const imageBytes = await new Promise<Uint8ClampedArray>((resolve, reject) => {
    const canvas = document.createElement("canvas");
    const context = canvas.getContext("2d");
    const image = new Image();
    image.onload = () => {
      canvas.width = image.width;
      canvas.height = image.height;
      context.drawImage(image, 0, 0);
      resolve(context.getImageData(0, 0, image.width, image.height).data);
    };
    image.src = imageUrl;
  });
  URL.revokeObjectURL(imageUrl);

  // Convert Image data to Pixel Array
  const pixels: number[] = [];
  for (let i = 0; i < imageBytes.length; i += 4) {
    const r = imageBytes[i];
    const g = imageBytes[i + 1];
    const b = imageBytes[i + 2];
    const a = imageBytes[i + 3];
    if (a < 255) {
      continue;
    }
    const argb = argbFromRgb(r, g, b);
    pixels.push(argb);
  }

  // Convert Pixels to Material Colors
  const result = QuantizerCelebi.quantize(pixels, 256);
  const ranked = Score.score(result);
  const top = ranked[0];
  return top;
}
