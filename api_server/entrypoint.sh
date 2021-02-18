#!/bin/bash
set -es
# remove existing unicorn pid
rm -f /var/www/html/app/tech_project_app/api_servertmp/pids/unicorn.pid
# move to api_server directory
cd /var/www/html/app/tech_project_app/api_server
# wait for mysql container started
dockerize -wait tcp://${MYSQL_HOST}:3306 -timeout 3m
# execute bundle install
bundle install
# create & migrate databse
rails db:create RAILS_ENV=${DOCKER_ENV}
rails db:migrate RAILS_ENV=${DOCKER_ENV}

# Then exec the container's main process
bundle exec unicorn_rails -p 3001 -c config/unicorn.rb -E ${DOCKER_ENV}
