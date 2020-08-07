#!/usr/bin/env bash
set -euo pipefail

npx -p @storybook/cli sb init --type react

mv storybook.main.js .storybook/main.js

yarn add \
@storybook/preset-typescript \
@storybook/addon-actions \
@storybook/preset-typescript \
ts-loader \
fork-ts-checker-webpack-plugin \
typescript \
@rollup/plugin-commonjs \
@rollup/plugin-node-resolve \
rollup-plugin-peer-deps-external \
rollup-plugin-typescript2 \
rollup-plugin-postcss

# modify package.json
node --experimental-modules editConfig.mjs && rm editConfig.mjs

rm readme.md
