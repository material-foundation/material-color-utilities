export default {
  srcDir: "src",
  srcFiles: [],
  specDir: ".",
  specFiles: [
    "quantize-webgpu/**/*_test.js"
  ],
  helpers: [
  ],
  esmFilenameExtension: ".js",
  enableTopLevelAwait: false,
  env: {
    stopSpecOnExpectationFailure: false,
    stopOnSpecFailure: false,
    random: true
  },
  listenAddress: "localhost",

  hostname: "localhost",

  browser: {
    name: "chrome",
    flags: [
      "--enable-unsafe-webgpu",
      "--enable-features=Vulkan,UseSkiaRenderer",
      "--enable-dawn-features=allow_unsafe_apis"
    ]
  },
  moduleType: "module"
};
