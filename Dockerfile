# docker build -t rozario .
# docker run -idt -v ./:/app/ --name rozario -p 3003:3003 rozario
# docker exec -it rozario ash
# docker attach rozario
# ctrl-p ctrl-q
# docker run -idt -v ./data/postgres:/var/lib/postgresql/data/ --name rozario-db -p 5432:5432 -e POSTGRES_USER=greport -e POSTGRES_PASSWORD=rozario postgres:alpine

FROM ruby:3.2-alpine AS build

WORKDIR /app
RUN apk update && apk add --no-cache build-base tzdata git nodejs libpq-dev
COPY Gemfile* ./
RUN bundle install
COPY . .
RUN if [ "${RAILS_ENV}" != "development" ]; then SECRET_KEY_BASE=blabla rails assets:precompile; fi


FROM ruby:3.2-alpine

WORKDIR /app

RUN apk update && apk add --no-cache build-base tzdata imagemagick vips git nodejs libpq-dev
# && addgroup -S appgroup && adduser -S -G appgroup -u 1000 appuser
#USER appuser

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app/public /public
COPY . .

