#!/bin/bash
set -u

# Assume this script is in the src directory and work from that location
PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

source "$PROJECT_ROOT/scripts/include.bash"

exec_in_container ./scripts/unit_tests.sh "$@"
