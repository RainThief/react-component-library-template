#!/usr/bin/env bash


IMAGE_NAME=${CI_IMAGE:-"defencedigital_react_lib_ci_support_image"}
PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/../"
CI="${CI:-false}"

_pushd(){
    command pushd "$@" > /dev/null
}

_popd(){
    command popd > /dev/null
}

exec_in_container() {
    _pushd "${PROJECT_ROOT}"
    docker build -t "$IMAGE_NAME" .
    _popd

    CONT_USER=$(id -u):$(id -g)
    OPTS="-it --init"

    if [ "$CI" == "true" ]; then
        CONT_USER=0
        OPTS="-t"
    fi

    mkdir -p "$PROJECT_ROOT/coverage"
    mkdir -p "$PROJECT_ROOT/storybook-static"
    mkdir -p "$PROJECT_ROOT/build"
    docker run --rm $OPTS -u="$CONT_USER" --name "$IMAGE_NAME" \
        -v "$PROJECT_ROOT/storybook-static:/usr/app/storybook-static" \
        -v "$PROJECT_ROOT/coverage:/usr/app/coverage" \
        -v "$PROJECT_ROOT/build:/usr/app/build" \
        -e "CI=$CI" \
        --network=host \
        "$IMAGE_NAME" "$@"
}

normalise_path() {
    # convert cygwin path for windows users
    if echo "$1" | grep -q cygdrive; then
        echo "$1" | sed -E -e 's/\/cygdrive\/([a-z])/\1:/g'
        return
    fi
    echo "$1"
}

exitonfail() {
    if [ "$1" -ne "0" ]
    then
        echo_danger "$2 failed"
        exit 1
    fi
}

warnonfail() {
    if [ "$1" -ne "0" ] && [ "$CI" != "true" ]
    then
        echo_warning "$2 warning"
        sleep 5
    fi
}

echo_colour() {
    colour=$2
    no_colour='\033[0m'
    echo -e "${colour}$1${no_colour}"
}

echo_warning(){
    yellow='\033[0;33;1m'
    echo_colour "$1" "${yellow}"
}

echo_success(){
    green='\033[0;32;1m'
    echo_colour "$1" "${green}"
}

echo_danger(){
    red='\033[0;31;1m'
    echo_colour "$1" "${red}"
}

echo_info(){
  cyan='\033[0;36;1m'
  echo_colour "$1" "${cyan}"
}
