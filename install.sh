#!/usr/bin/env bash
set -euo pipefail

npx -p @storybook/cli sb init --type react

mv storybook.main.js .storybook/main.js

yarn add \
# typescript
typescript@^3.9.7, \
# storybook
@storybook/addon-actions@^5.3.19, \
@storybook/preset-typescript@^3.0.0, \
ts-loader@^8.0.2, \
# rollup
rollup@^2.23.1, \
@rollup/plugin-commonjs@^14.0.0, \
@rollup/plugin-node-resolve@^8.4.0, \
rollup-plugin-peer-deps-external@^2.2.3, \
rollup-plugin-typescript2@^0.27.2, \
rollup-plugin-postcss@^3.1.5, \
fork-ts-checker-webpack-plugin@^5.0.14, \
#eslint
eslint@^7.6.0, \
eslint-plugin-react@^7.20.5, \
@typescript-eslint/eslint-plugin@^3.8.0, \
@typescript-eslint/parser@^3.8.0 \
eslint-config-react-app@^5.2.1 \
eslint-plugin-jest@^23.13.1 \
eslint-plugin-react@^7.20.0 \
eslint-plugin-react-hooks@^4.0.4 \
eslint-plugin-security@^1.4.0 \
eslint-plugin-import@^2.21.2 \
@typescript-eslint/parser \
#stylelint
stylelint@^13.5.0 \
stylelint-config-standard@^20.0.0 \
stylelint-scss@^3.17.2 \

# modify package.json
node --experimental-modules editConfig.mjs && rm editConfig.mjs

# mv readme.lib.md readme.md
