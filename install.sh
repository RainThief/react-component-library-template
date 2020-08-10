#!/usr/bin/env bash
set -euo pipefail

npx -p @storybook/cli sb init --type react

yarn install

# modify package.json
node --experimental-modules editConfig.mjs && rm editConfig.mjs

# overwrite storybook default config
# mv storybook.main.js .storybook/main.js

# overwrite readme
# mv readme.lib.md readme.md
