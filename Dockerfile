FROM ruby:3.0-slim

RUN apt update && apt upgrade -y

RUN apt install --no-install-recommends -y \
	git \
	sqlite3 \
	bash \
	vim \
	less \
	build-essential \
	libsqlite3-dev

COPY ./app /graphql

WORKDIR /graphql

EXPOSE 9000 3000

RUN rm -f Gemfile.lock && bundle install

COPY docker-entrypoint.sh /usr/local/bin

RUN chmod 0755 /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["bash", "-c", "docker-entrypoint.sh"]
