# frozen_string_literal: true

# controller for scraping
class Api::V1::ScrapingController < ApplicationController
  # scrape_midworks action
  def scrape_midworks
    pjt_json_list = MidworksScrapingService.scraping_root
    result_flg = ScrapingService.compose_project_json pjt_json_list
    res_json = ResponseService.scraping_response_json pjt_json_list, result_flg
    render json: res_json
  end

  # scrape_levtech action
  def scrape_levtech
    pjt_json_list = LevtechScrapingService.scraping_root
    result_flg = ScrapingService.compose_project_json pjt_json_list
    res_json = ResponseService.scraping_response_json pjt_json_list, result_flg
    render json: res_json
  end

  # scrape_potepan action
  def scrape_potepan
    pjt_json_list = PotepanScrapingService.scraping_root
    result_flg = ScrapingService.compose_project_json pjt_json_list
    res_json = ResponseService.scraping_response_json pjt_json_list, result_flg
    render json: res_json
  end
end
