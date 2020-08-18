#!/usr/bin/env bash
set -uo pipefail

# Assume this script is in the src directory and work from that location
PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

source "$PROJECT_ROOT/scripts/include.bash"

start_container

docker exec -t "$IMAGE_NAME" ./scripts/audit.sh

docker stop "$IMAGE_NAME" >> /dev/null 2>&1
