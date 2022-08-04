import { defineConfig } from "vite";

export default defineConfig({
  build: {
    lib: {
      entry: "index.ts",
      name: "MaterialColorUtilities",
      fileName: (format) => `material-color-utilities.${format}.js`,
    },
  },
});
