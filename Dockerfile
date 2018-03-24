FROM ruby:2.4.2-alpine

ENV LC_ALL=C.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

COPY Gemfile Gemfile.lock /app/

RUN apk --update add --virtual build-dependencies ruby-dev build-base postgresql-dev bash && \
    gem install bundler --no-ri --no-rdoc && \
    cd /app && \
    bundle install --without development test components && \
    rm -rf /var/cache/apk/*

WORKDIR /app
COPY . /app

RUN cd /app && \
    bundle config --delete without && \
    bundle install

CMD ["bundle", "exec", "lita"]