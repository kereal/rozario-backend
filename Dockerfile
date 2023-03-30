# docker build -t rozario .
# docker run -idt -v ./:/app/ --name rozario -p 3003:3003 rozario
# docker exec -it rozario ash
# docker attach rozario
# ctrl-p ctrl-q
# docker run -idt -v ./data/postgres:/var/lib/postgresql/data/ --name rozario-db -p 5432:5432 -e POSTGRES_USER=greport -e POSTGRES_PASSWORD=rozario postgres:alpine

FROM ruby:3.2-alpine

RUN apk update && apk add --no-cache build-base tzdata imagemagick vips git openssh nodejs libpq-dev
ENV BUNDLE_WITHOUT=development BUNDLE_JOBS=4

WORKDIR /app

COPY Gemfile* ./
RUN bundle install

COPY ./.ssh /root/.ssh/

COPY . .

CMD rm -f tmp/pids/server.pid && bundle exec rails s -b 0.0.0.0 -p 3003