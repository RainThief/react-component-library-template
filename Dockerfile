FROM node:12-alpine

RUN apk add --no-cache bash git jq

RUN yarn global add license-checker

WORKDIR /usr/app

COPY package.json package.json

COPY yarn.lock yarn.lock

# allow 'prepare' script to fail on yarn install
RUN yarn install; exit 0

RUN chmod  777 -c /usr/app/node_modules

RUN chmod  777 -c /usr/app

COPY . /usr/app/

ENV SKIP_PREFLIGHT_CHECK=true

# make yarn cli colourful
ENV FORCE_COLOR=1
