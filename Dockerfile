# Development image: run the specs, RuboCop and a console without installing Ruby locally.
#
#   docker build -t deep_freezer-dev .
#   docker run --rm -v "$PWD":/app deep_freezer-dev            # rake (specs + RuboCop)
#   docker run --rm -v "$PWD":/app deep_freezer-dev bundle exec rspec
#
# Test against another Ruby or Rails release with build arguments:
#
#   docker build -t deep_freezer-dev --build-arg RUBY_VERSION=3.2 --build-arg ACTIVERECORD_VERSION=7.1 .
ARG RUBY_VERSION=3.4
FROM ruby:${RUBY_VERSION}-slim

RUN apt-get update \
    && apt-get install --no-install-recommends -y build-essential git \
    && rm -rf /var/lib/apt/lists/*

# Same variable the CI matrix uses; Gemfile pins activerecord and railties to it.
ARG ACTIVERECORD_VERSION
ENV ACTIVERECORD_VERSION=${ACTIVERECORD_VERSION}

WORKDIR /app

# Copy only what bundler needs first so the gem layer is cached until dependencies change.
COPY Gemfile deep_freezer.gemspec ./
COPY lib/deep_freezer/version.rb lib/deep_freezer/version.rb
RUN bundle install

COPY . .

CMD ["bundle", "exec", "rake"]
