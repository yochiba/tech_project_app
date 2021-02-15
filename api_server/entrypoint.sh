#!/bin/bash
set -es
# remove existing unicorn pid
rm -f /var/www/html/app/tech_project_app/api_servertmp/pids/unicorn.pid
# move to api_server directory
cd /var/www/html/app/tech_project_app/api_server
# execute bundle install
bundle install
# wait for mysql container started
dockerize -wait tcp://mysql:3306 -timeout 3m
# create & migrate databse
rails db:create RAILS_ENV=${DOCKER_ENV}
rails db:migrate RAILS_ENV=${DOCKER_ENV}

# Then exec the container's main process (what's set as CMD in the Dockerfile).
bundle exec unicorn_rails -p 3001 -c config/unicorn.rb -E ${DOCKER_ENV}
