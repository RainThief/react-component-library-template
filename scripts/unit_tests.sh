#!/usr/bin/env bash
set -u

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)/../"

source "$PROJECT_ROOT/scripts/include.sh"

COVERAGE=""

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -c|--coverage)
    COVERAGE="--coverage"
    shift
    ;;
    *)
    shift
    ;;
esac
done

export NODE_ENV=test

npx jest --colors --watchAll=false "$COVERAGE" --updateSnapshot
exitonfail $? "Unit tests"

echo_success "Unit tests passed"
