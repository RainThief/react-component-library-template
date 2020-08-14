#!/usr/bin/env bash

CI=${CI:-false}
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

_pushd(){
    command pushd "$@" > /dev/null
}

_popd(){
    command popd "$@" > /dev/null
}

build_tmp_image() {
_pushd "${PROJECT_ROOT}"
docker build -t "$@" . -f-<<EOF
FROM node:12-alpine
RUN apk add --no-cache bash
WORKDIR /usr/app
COPY package.json package.json
COPY yarn.lock yarn.lock
RUN yarn global add license-checker
RUN yarn install
RUN chmod  777 -c /usr/app/node_modules
RUN chmod  777 -c /usr/app
RUN ls -la /usr/app
ENV SKIP_PREFLIGHT_CHECK=true
EOF
_popd
}

start_container() {
    STATE=${1:-"detach"}
    shift
    CMD=${@-""}

    build_tmp_image "$IMAGE_NAME"

    OPTS="-dt"
    ENTRY="-entrypoint /bin/bash"

    if [ "$STATE" == "interactive" ]; then
        OPTS="-it --init"
        ENTRY="--"
    fi

    docker run --rm $OPTS -u=$(id -u):$(id -g) --name "$IMAGE_NAME" \
    -u "$CONT_USER" \
    -v "$PROJECT_ROOT/src:/usr/app/src" \
    -v "$PROJECT_ROOT/.eslintrc:/usr/app/.eslintrc" \
    -v "$PROJECT_ROOT/.eslintignore:/usr/app/.eslintignore" \
    -v "$PROJECT_ROOT/.stylelintrc:/usr/app/.stylelintrc" \
    -v "$PROJECT_ROOT/tsconfig.json:/usr/app/tsconfig.json" \
    -v "$PROJECT_ROOT/rollup.config.js:/usr/app/rollup.config.js" \
    -v "$PROJECT_ROOT/jest.config.js:/usr/app/jest.config.js" \
    -v "$PROJECT_ROOT/.storybook:/usr/app/.storybook" \
    -v "$PROJECT_ROOT/storybook-static:/usr/app/storybook-static" \
    --network=host \
    "$ENTRY" "$(get_image_name $PROJECT_ROOT)" $CMD
}

run_container_interactive() {
    start_container interactive $@
}

get_image_name() {
    echo "tmp-$(basename -- $1)-image"
}

normalise_path() {
    # convert cygwin path
    if [ $(echo "$1" | grep cygdrive) ]; then
        echo "$1" | sed -r -e 's/\/cygdrive\/([a-z])/\1:/g'
        return
    fi
    echo "$1"
}

implode() {
    local IFS="$1";
    shift;
    echo "$*";
}

exitonfail() {
    if [ "$1" -ne "0" ]
    then
        echo_danger "$2 failed"
        IMAGE_NAME="$(get_image_name $PROJECT_ROOT)"
        if [ ! -z "${IMAGE_NAME}" ]; then
            docker stop "$IMAGE_NAME" >> /dev/null 2>&1
        fi
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
    magenta='\033[0;33;1m'
    echo_colour "$1" "${magenta}"
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

IMAGE_NAME="$(get_image_name $PROJECT_ROOT)"

CONT_USER=$(id -u):$(id -g)
if [ "$CI" == "true" ]; then
    CONT_USER=0
fi
