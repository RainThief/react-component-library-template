#!/bin/bash
set -uo pipefail

source "./scripts/include.sh"

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
    npx start-storybook -p 6006
    exit 0
fi

npx build-storybook
exitonfail $? "Storybook gen"
