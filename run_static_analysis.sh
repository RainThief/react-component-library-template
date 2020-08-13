#!/usr/bin/env bash
set -uo pipefail

# Assume this script is in the src directory and work from that location
PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

source "$PROJECT_ROOT/scripts/include.bash"

ESLINT_OPT="--fix"

if [ "$CI" == "true" ]; then
    ESLINT_OPT="--quiet"
fi

start_container

docker exec "$IMAGE_NAME" npx eslint "$ESLINT_OPT" --color ./src -c .eslintrc --ext .ts,.tsx,.js,.jsx
exitonfail $? "Eslint"

docker exec "$IMAGE_NAME" npx stylelint --color "**/*.{css,scss,sass}"
exitonfail $? "Stylelint"

docker stop "$IMAGE_NAME" >> /dev/null 2>&1

echo_success "Static analysis passed"
