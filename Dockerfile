FROM ruby:3.2.1-alpine AS build

WORKDIR /app
RUN apk update && apk add --no-cache build-base tzdata git nodejs libpq-dev \
  && addgroup --g 1000 appgroup && adduser -S -G appgroup -u 1000 appuser \
  && chown appuser:appgroup -R /app

USER appuser

COPY --chown=appuser:appgroup Gemfile* ./

RUN bundle config set without "development test" \
  && bundle install \
  && rm -rf /usr/local/bundle/cache/*

COPY --chown=appuser:appgroup . .
RUN if [ "${RAILS_ENV}" != "development" ]; then SECRET_KEY_BASE=blabla rails assets:precompile; fi


FROM ruby:3.2.1-alpine

WORKDIR /app

RUN apk update && apk add --no-cache tzdata imagemagick vips nodejs \
  && addgroup --g 1000 appgroup && adduser -S -G appgroup -u 1000 appuser \
  && chown appuser:appgroup -R /app

COPY --chown=appuser:appgroup --from=build /usr/local/bundle /usr/local/bundle
COPY --chown=appuser:appgroup --from=build /app/public /public
COPY --chown=appuser:appgroup . .
