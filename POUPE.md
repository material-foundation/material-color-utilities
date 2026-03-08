# Poupe Fork

This is a fork of [Material Color Utilities][upstream] maintained
by [Poupe UI][poupe]. It exists solely to publish the TypeScript
package as [`@poupe/material-color-utilities`][npm] on npm, kept
in sync with the upstream repository.

[upstream]: https://github.com/material-foundation/material-color-utilities
[poupe]: https://github.com/poupe-ui
[npm]: https://www.npmjs.com/package/@poupe/material-color-utilities

## Why this fork exists

Google maintains the source on GitHub but has historically been
slow to publish the TypeScript package to npm. This fork bridges
that gap by publishing timely releases under the `@poupe` scope.

## What has changed

No functional code is modified. All changes fall into three
categories: packaging, import fixes, and CI.

### Packaging

- Renamed the npm package from
  `@material/material-color-utilities` to
  `@poupe/material-color-utilities`.
- Updated `repository.url` in `typescript/package.json` to
  point to this fork.
- Switched the package manager from npm to pnpm, with
  `packageManager` fields and lock files at both the root and
  `typescript/` levels.
- Added `pkg-pr-new` as a dev dependency (`~` range) for
  PR preview builds.
- Added fork disclaimer banners to `README.md` and
  `typescript/README.md`.
- Fixed a typo in the upstream `README.md`
  ("Ultilities" to "Utilities").

### Import fixes

Upstream TypeScript sources use bare specifiers (without `.js`
extensions) in several imports, which breaks strict ESM module
resolution. This fork appends the `.js` extension where
missing. Five distinct bare specifiers are affected:

- `./dynamic_color` — in `color_spec.ts`, `color_spec_2025.ts`,
  `color_spec_2026.ts`
- `./dynamic_scheme` — in `color_spec_2021.ts`,
  `color_spec_2025.ts`, `material_dynamic_colors.ts`
- `./color_spec` — in `dynamic_color.ts`
- `../palettes/tonal_palette` — in `dynamic_color.ts`
- `../dynamiccolor/dynamic_scheme` — in `scheme_cmf.ts`,
  `scheme_content.ts`, `scheme_expressive.ts`,
  `scheme_fidelity.ts`, `scheme_fruit_salad.ts`,
  `scheme_monochrome.ts`, `scheme_neutral.ts`,
  `scheme_rainbow.ts`, `scheme_tonal_spot.ts`,
  `scheme_vibrant.ts`

All paths are relative to `typescript/`.

### CI

- Added `.github/workflows/pkg-pr-new.yml`, a GitHub Actions
  workflow that publishes a preview package on every pull
  request using `pkg-pr-new`.

## Syncing with upstream

The `upstream` remote points to the original repository. To
merge new upstream changes:

```sh
git fetch upstream
git merge upstream/main
```

After merging, check for new bare imports that need the `.js`
extension fix:

```sh
grep -rn "from '\." typescript/ --include='*.ts' \
  | grep -v '\.js' \
  | grep -v '_test\.ts' \
  | grep -v node_modules
```

Resolve any conflicts in `typescript/package.json` keeping the
`@poupe` package name and our repository URL, whilst adopting
upstream's version number and structural changes.
