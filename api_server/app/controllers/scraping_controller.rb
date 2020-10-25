# frozen_string_literal: true

# controller for scraping
class ScrapingController < ApplicationController
  def scrape_midworks
    project_json_array = MidworksScrapingService.compose_projects_json

    response_json = ProjectService.compose_project_json project_json_array

    # 下記のJsonは仮置き
    response_json = {
      project_count: project_json_array.size,
      projects_list: project_json_array,
      status: 200,
      result: 'OK',
    }
    # TODO ここにDB登録する用のメソッド追加(共通メソッドにする)
    render json: response_json
  end
end
