# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # scraping controller
      get '/scrape-midworks', to: 'scraping#scrape_midworks'
      get '/scrape-levtech', to: 'scraping#scrape_levtech'
    end
  end
end
