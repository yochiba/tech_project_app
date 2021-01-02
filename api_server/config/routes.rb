# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  # sidekiq dashboard
  mount Sidekiq::Web, at: "/sidekiq"

  namespace :api do
    namespace :v1 do
      # scraping controller
      get '/scrape-midworks', to: 'scraping#scrape_midworks'
      get '/scrape-levtech', to: 'scraping#scrape_levtech'
      get '/scrape-potepan', to: 'scraping#scrape_potepan'
      # projects controller
      # get '/projects/index', to: 'projects#index'
      # get '/projects/show', to: 'projects#show'
      # search controller
      get '/search/index', to: 'search#index'
      get '/search/show', to: 'search#show'
      get '/search/checkbox-items', to: 'search#checkbox_items'
    end
  end
end
