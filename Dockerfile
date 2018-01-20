FROM ruby:2.5.1-alpine

RUN apk add --no-cache git

WORKDIR /app

COPY lib/language_server/version.rb /app/lib/language_server/
COPY Gemfile language_server.gemspec /app/

RUN bundle install --without development

COPY lib /app/lib/
COPY exe /app/exe/

CMD ["bundle", "exec", "exe/language_server-ruby"]
