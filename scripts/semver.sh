#!/usr/bin/env bash

SEMVER="patch"

while [[ "$#" -gt 0 ]]
do
    key="$1"

    # bump version type based on arg passed
    case $key in
        minor)
        SEMVER="minor"
        shift
        ;;
        major)
        SEMVER="major"
        shift
        ;;
        *)
        shift
        ;;
    esac
done

yarn version --new-version "$SEMVER"
