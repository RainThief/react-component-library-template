FROM node:12-alpine

RUN apk add --no-cache bash=5.0.11-r1 git=2.24.3-r0 jq=1.6-r0 curl=7.67.0-r1

# install hadolint (Dockerfile linter)
RUN curl -L "https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64"  -o "hadolint" \
  && chmod +x hadolint \
  && mv hadolint /usr/local/bin/hadolint

# install shellcheck (bash linter)
RUN curl -L "https://github.com/koalaman/shellcheck/releases/download/v0.7.1/shellcheck-v0.7.1.linux.x86_64.tar.xz"  -o "shellcheck.tar.xz" \
  && tar xf shellcheck.tar.xz \
  && mv shellcheck-v0.7.1/shellcheck /usr/local/bin/shellcheck \
  && chmod +x /usr/local/bin/shellcheck \
  && rm -Rf shellcheck*

WORKDIR /usr/app

COPY package.json package.json

COPY yarn.lock yarn.lock

# allow 'prepare' script to fail on rollup and install.js
RUN yarn install; exit 0

RUN chmod  777 -c /usr/app/node_modules

RUN chmod  777 -c /usr/app

COPY . /usr/app/

ENV SKIP_PREFLIGHT_CHECK=true

# make yarn cli colourful
ENV FORCE_COLOR=1
