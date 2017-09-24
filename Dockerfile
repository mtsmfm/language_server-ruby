FROM ruby:2.4.2-alpine

WORKDIR /app

COPY lib/language_server/version.rb /app/lib/language_server/
COPY Gemfile language_server.gemspec /app/

RUN bundle install --without development

COPY lib /app/lib/
COPY exe /app/exe/

CMD ["bin/language_server-ruby"]
