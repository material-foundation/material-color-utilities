# material-color-utilities

[![npm package version](https://badgen.net/npm/v/@guidezpl/material-color-utilities)](https://npmjs.com/package/@material/material-color-utilities)

Algorithms and utilities that power the Material Design 3 (M3) color system,
including choosing theme colors from images and creating tones of colors; all in
a new color space.

See the main
[README](https://github.com/material-foundation/material-color-utilities#readme)
for more information.

## Getting started

`npm install @material/material-color-utilities`

OR

`yarn add @material/material-color-utilities`

```typescript
import { HCT } from "@material/material-color-utilities";

// Simple demonstration of HCT.
const color = HCT.fromInt(0xff4285f4);
console.log(`Hue: ${color.hue}`);
console.log(`Chrome: ${color.chroma}`);
console.log(`Tone: ${color.tone}`);
```

## Contributing

This repo is not accepting external contributions, but feature requests and bug
reports are welcome on
[GitHub](https://github.com/material-foundation/material-color-utilities/issues).
