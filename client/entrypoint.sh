#!/bin/bash
cd /var/www/html/app/tech_app_project/client

yarn install && yarn build-${NODE_ENV}

yarn start