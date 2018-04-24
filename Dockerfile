FROM ruby:2.4.1

MAINTAINER Eyal.stoler@kenshoo.com

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN apt-get install -y imagemagick
RUN apt-get update

ARG MYSQL_DATABASE='spreedb'
ARG MYSQL_HOST='127.0.0.1'
ARG MYSQL_PASSWORD
ARG MYSQL_USER='root'

ENV MYSQL_DATABASE $MYSQL_DATABASE 
ENV MYSQL_HOST $MYSQL_HOST
ENV MYSQL_PASSWORD $MYSQL_PASSWORD
ENV MYSQL_USER $MYSQL_USER
ENV APP_HOME /app

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME

RUN rails db:migrate

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
