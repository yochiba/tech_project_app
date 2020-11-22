# frozen_string_literal: true

# controller for scraping
class Api::V1::ScrapingController < ApplicationController
  # scrape_midworks action
  def scrape_midworks
    project_json_array = MidworksScrapingService.scraping_root
    result_flg = ScrapingService.compose_project_json project_json_array
    render json: response_json(project_json_array, result_flg)
  end

  # scrape_levtech action
  def scrape_levtech
    project_json_array = LevtechScrapingService.scraping_root
    result_flg = ScrapingService.compose_project_json project_json_array
    render json: response_json(project_json_array, result_flg)
  end

  # scrape_potepan action
  def scrape_potepan
    project_json_array = PotepanScrapingService.scraping_root
    result_flg = ScrapingService.compose_project_json project_json_array
    render json: response_json(project_json_array, result_flg)
  end

  private

  # response_json format for scraping
  def response_json(project_json_array, result_flg)
    response_json = {

      project_count: project_json_array.size,
      project_list: project_json_array,
      status: result_flg ? Settings.response.ok.status : Settings.response.error.status,
      result: result_flg ? Settings.response.ok.result : Settings.response.error.result,
    }
    response_json
  end
end
