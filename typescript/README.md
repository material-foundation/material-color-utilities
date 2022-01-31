# Example

```js
import { argbFromHex, themeFromSeed } from "@material/color-utilities";

const theme = themeFromSeed(argbFromHex('#f82506'), [
  {
    name: "custom-1",
    value: argbFromHex("#ff0000"),
    blend: true,
  },
]);
console.log(JSON.stringify(theme, null, 2));

```

## Troubleshooting

If using node make sure to use the following flag:

```
node --experimental-specifier-resolution=node
```
