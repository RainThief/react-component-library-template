#!/usr/bin/env bash
set -uo pipefail

# Assume this script is in the src directory and work from that location
PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

source "$PROJECT_ROOT/scripts/include.bash"

__DIR__="$(normalise_path ${PROJECT_ROOT})"

start_container

ALLOWED_LICENSES=$(docker exec -i "$IMAGE_NAME" echo "$(cat ./node_modules/r2d2-lint-config/licenses.json)" | \
docker exec -i "$IMAGE_NAME" jq -c '.[]')

docker exec -t "$IMAGE_NAME" npx license-checker --onlyAllow "$(echo $ALLOWED_LICENSES | sed -E "s/\" /;/g" | sed -E "s/\"//g")"
exitonfail $? "License check"

docker exec -t "$IMAGE_NAME" yarn audit
EXIT=$?

docker exec -t "$IMAGE_NAME" yarn outdated
warnonfail $? "Checking all dependencies up to date"

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
