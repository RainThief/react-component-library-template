#!/usr/bin/env bash
set -uo pipefail

# Assume this script is in the src directory and work from that location
PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

source "$PROJECT_ROOT/scripts/include.bash"

__DIR__="$(normalise_path ${PROJECT_ROOT})"

ALLOWED_LICENSES=(
    "MIT"
    "Apache-2.0"
    "CC0-1.0"
    "BSD"
    "BSD-2-Clause"
    "BSD-3-Clause"
    "ISC"
    "CC-BY-3.0"
    "CC-BY-4.0"
    "Public Domain"
    "WTFPL"
    "Unlicense"
)

start_container


run "License check" npx license-checker --onlyAllow \
"$(implode ";" "${ALLOWED_LICENSES[@]}")"

docker exec -t "$IMAGE_NAME" yarn audit
EXIT=$?

docker exec -t "$IMAGE_NAME" yarn outdated
exitonfail $? "Checking all dependencies up to date"

docker stop "$IMAGE_NAME" >> /dev/null 2>&1

if [ $EXIT -gt 3 ]; then
    echo_danger "Security audit failed"
    exit 1
fi
if [ $EXIT -gt 0 ]; then
    echo_warning "Security audit passed with warnings"
    exit 1
fi

echo_success "Audit passed"
