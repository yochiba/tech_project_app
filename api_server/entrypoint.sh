#!/bin/bash
set -es
# remove existing unicorn pid
rm -f /var/www/html/app/tech_project_app/api_servertmp/pids/unicorn.pid
# move to api_server directory
cd /var/www/html/app/tech_project_app/api_server
# wait for mysql container started
dockerize -wait tcp://${MYSQL_HOST}:${MYSQL_PORT} -timeout 3m
# execute bundle install
bundle install
# create & migrate databse
bundle exec rails db:create RAILS_ENV=${DOCKER_ENV}
bundle exec rails db:migrate RAILS_ENV=${DOCKER_ENV}
# activate sidekiq
bundle exec sidekiq -d -C config/sidekiq.yml --logfile ./log/sidekiq-${DOCKER_ENV}.log
# Then exec the container's main process
bundle exec unicorn_rails -p 3001 -c config/unicorn.rb -E ${DOCKER_ENV}