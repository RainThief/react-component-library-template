FROM node:12-alpine as builder

RUN apk add --no-cache curl=7.67.0-r3

# install hadolint (Dockerfile linter)
RUN curl -L "https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64"  -o "hadolint" \
  && chmod +x hadolint \
  && mv hadolint /usr/local/bin/hadolint

# install shellcheck (bash linter)
RUN curl -L "https://github.com/koalaman/shellcheck/releases/download/v0.7.1/shellcheck-v0.7.1.linux.x86_64.tar.xz"  -o "shellcheck.tar.xz" \
  && tar xf shellcheck.tar.xz \
  && mv shellcheck-v0.7.1/shellcheck /usr/local/bin/shellcheck \
  && chmod +x /usr/local/bin/shellcheck

WORKDIR /usr/app

COPY package.json package.json

COPY yarn.lock yarn.lock

# allow 'prepare' script to fail on rollup and install.js
RUN yarn install; exit 0



FROM node:12-alpine

RUN apk add --no-cache \
    bash=5.0.11-r1 \
    git=2.24.3-r0 \
    jq=1.6-r0

COPY --from=builder /usr/local/bin/hadolint /usr/local/bin/hadolint

COPY --from=builder /usr/local/bin/shellcheck /usr/local/bin/shellcheck

COPY --from=builder /usr/app/node_modules /usr/appcache/node_modules

# allow internal .cache folder to be created by non root user
RUN chmod 777 /usr/appcache/node_modules

WORKDIR /usr/app

ENV SKIP_PREFLIGHT_CHECK=true

# make yarn cli colourfull
ENV FORCE_COLOR=1

WORKDIR /usr/app
