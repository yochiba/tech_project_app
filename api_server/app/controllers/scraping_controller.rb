# frozen_string_literal: true

# controller for scraping
class ScrapingController < ApplicationController
  def scrape_midworks
    project_json_array = MidworksScrapingService.compose_projects_json
    result_flg = ProjectService.compose_project_json project_json_array
    render json: {
      project_count: project_json_array.size,
      projects_list: project_json_array,
      status: result_flg ? Settings.response.ok.status : Settings.response.error.status,
      result: result_flg ? Settings.response.ok.result : Settings.response.error.result,
    }
  end
end
