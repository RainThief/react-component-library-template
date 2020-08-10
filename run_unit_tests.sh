#!/bin/bash
set -uo pipefail

# Assume this script is in the src directory and work from that location
PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

source "$PROJECT_ROOT/scripts/include.bash"

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

start_container

run "Unit tests" /bin/bash -c export NODE_ENV=test && npx jest "$COVERAGE"

docker stop "$IMAGE_NAME" >> /dev/null 2>&1

echo_success "Unit tests passed"
