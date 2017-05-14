FROM ruby:2.4.1

RUN apt-get update && apt-get install less -y
RUN groupadd --gid 1000 ruby && useradd --uid 1000 --gid ruby --shell /bin/bash --create-home ruby
RUN mkdir /app && chown ruby:ruby /app

ENV LANG=C.UTF-8 \
  BUNDLE_PATH=/app/vendor/bundle \
  BUNDLE_JOBS=4

USER ruby
WORKDIR /app
CMD ["bundle", "exec", "exe/languageserver"]
