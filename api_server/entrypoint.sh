#!/bin/bash
set -e

rm -f /tech_project_app/tmp/pids/server.pid

# TODO change the command after RAILS_ENV= depends on environment
pwd
rails db:create RAILS_ENV=development
rails db:migrate RAILS_ENV=development

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"