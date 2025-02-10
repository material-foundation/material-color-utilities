export function floatArrayToHex(colors: Float32Array): string[] {
    const hexColors: string[] = [];
    for (let i = 0; i < colors.length; i += 3) {
        const r = Math.round(colors[i] * 255).toString(16).padStart(2, '0');
        const g = Math.round(colors[i + 1] * 255).toString(16).padStart(2, '0');
        const b = Math.round(colors[i + 2] * 255).toString(16).padStart(2, '0');
        hexColors.push(`#${r}${g}${b}`);
    }
    return hexColors;
}
