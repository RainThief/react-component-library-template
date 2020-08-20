#!/usr/bin/env bash
set -uo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)/../"

source "$PROJECT_ROOT/scripts/include.bash"

ALLOWED_LICENSES=$(echo "$(cat ./node_modules/@defencedigital/r2d2-lint-config/licenses.json)" | jq -c '.[]')
if [ "$ALLOWED_LICENSES" == "" ]; then
    exitonfail 1 "License list import"
fi

npx license-checker --onlyAllow "$(echo $ALLOWED_LICENSES | sed -E "s/\" /;/g" | sed -E "s/\"//g")"
exitonfail $? "License check"

yarn audit
EXIT=$?

yarn outdated
warnonfail $? "Not all dependencies up to date"

if [ $EXIT -gt 3 ]; then
    echo_danger "Security audit failed"
    exit 1
fi
if [ $EXIT -gt 0 ]; then
    echo_warning "Security audit passed with warnings"
    exit 1
fi

echo_success "Audit passed"
