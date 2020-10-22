# frozen_string_literal: true

Rails.application.routes.draw do
  # scraping controller
  get '/scrape-midworks', to: 'scraping#scrape_midworks'
end
