#!/bin/bash
set -uo pipefail

# Assume this script is in the src directory and work from that location
PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

source "$PROJECT_ROOT/scripts/include.bash"

STATIC="false"

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -s|--static)
    STATIC="true"
    shift
    ;;
    *)
    shift
    ;;
esac
done

if [ "$STATIC" == "false" ]; then
    run_container_interactive npx start-storybook -p 6006
    exit 0
fi

mkdir -p "$PROJECT_ROOT/storybook-static"

start_container

docker exec "$IMAGE_NAME" npx build-storybook
exitonfail $? "Storybook gen"

docker stop "$IMAGE_NAME" >> /dev/null 2>&1
