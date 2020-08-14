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
ENV SKIP_PREFLIGHT_CHECK=true
EOF
_popd
}

start_container() {
    IMAGE_NAME="$(get_image_name $PROJECT_ROOT)"

    build_tmp_image "$IMAGE_NAME"

    CONT_USER=$(id -u):$(id -g)
    if [ "$CI" == "true" ]; then
        CONT_USER=0
    fi

    docker run --rm -dt -u=$(id -u):$(id -g) --name "$IMAGE_NAME" \
    -u "$CONT_USER" \
    -v "$PROJECT_ROOT/src:/usr/app/src" \
    -v "$PROJECT_ROOT/.eslintrc:/usr/app/.eslintrc" \
    -v "$PROJECT_ROOT/.eslintignore:/usr/app/.eslintignore" \
    -v "$PROJECT_ROOT/.stylelintrc:/usr/app/.stylelintrc" \
    -v "$PROJECT_ROOT/tsconfig.json:/usr/app/tsconfig.json" \
    --entrypoint /bin/bash \
    "$(get_image_name $PROJECT_ROOT)"
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
