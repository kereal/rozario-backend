FROM ruby:3.2.2-alpine AS build

ARG RAILS_ENV
WORKDIR /app

RUN apk add --no-cache build-base tzdata git nodejs libpq-dev

COPY Gemfile* ./

RUN if [ "${RAILS_ENV}" != "development" ]; then bundle config set without "development test"; fi
RUN bundle install

COPY . .

RUN if [ "${RAILS_ENV}" != "development" ]; then SECRET_KEY_BASE=blabla rails assets:precompile; fi


FROM ruby:3.2.2-alpine

WORKDIR /app
USER appuser

RUN apk add --no-cache tzdata libpq-dev imagemagick vips nodejs \
  && addgroup --g 1003 appgroup && adduser -S -G appgroup -u 1002 appuser \
  && chown appuser:appgroup -R /app

COPY --chown=appuser:appgroup --from=build /usr/local/bundle /usr/local/bundle
COPY --chown=appuser:appgroup --from=build /app/public /public
COPY --chown=appuser:appgroup . .
