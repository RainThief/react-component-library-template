#!/usr/bin/env bash


IMAGE_NAME=${CI_IMAGE:-"react_lib_ci_support_image"}
PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/../"
CI="${CI:-false}"


_pushd(){
    command pushd "$@" > /dev/null
}


_popd(){
    command popd > /dev/null
}


exec_in_container() {
    CONT_USER=$(id -u):$(id -g)
    OPTS="-it --init"
    EXEC_OPTS="-it"

    if [ "$CI" == "true" ]; then
        CONT_USER=0
        EXEC_OPTS="-t"
        OPTS="-t"
        docker login "$DOCKER_REG" -u "$DOCKER_USER" -p "$DOCKER_PASS"
    fi

    mkdir -p "$PROJECT_ROOT/coverage"
    mkdir -p "$PROJECT_ROOT/storybook-static"
    mkdir -p "$PROJECT_ROOT/build"

    if ! docker pull "$IMAGE_NAME"; then
        _pushd "${PROJECT_ROOT}"
        docker build --pull -t "$IMAGE_NAME" -f ./scripts/Dockerfile .
        exitonfail $? "Docker build"
        _popd
    fi

    CONT_NAME=$(basename "$IMAGE_NAME" | sed -r 's/:(.*)//' )

    mv_node_modules

    docker run --rm -d $OPTS -u="$CONT_USER" --name "$CONT_NAME" \
        -v "$PROJECT_ROOT:/usr/app" \
        -e "CI=$CI" \
        --network=host \
        "$IMAGE_NAME" /bin/bash

    docker exec $EXEC_OPTS "$CONT_NAME" ln -s /usr/appcache/node_modules node_modules

    docker exec $EXEC_OPTS "$CONT_NAME" "$@"
    EXIT_CODE=$?

    docker stop "$CONT_NAME"

    mv_node_modules

    return $EXIT_CODE
}

# node modules may contain incompaitble binaries accross platforms so ignore host copy
mv_node_modules() {
    # not going to exist on ci
    if [ "$CI" == "true" ]; then return; fi

    if [ -d "node_modules" ]; then
            mv "node_modules" "_node_modules"
    fi
    if [ -L "node_modules" ]; then
        rm node_modules
        mv "_node_modules" "node_modules"
    fi
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
