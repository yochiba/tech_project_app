# frozen_string_literal: true

# controller for scraping
class ScrapingController < ApplicationController
  def scrape_midworks
    projects_json_array = MidworksScrapingService.compose_projects_json

    # response_json = ProjectService.create_projects projects_json_array

    # 下記のJsonは仮置き
    response_json = {
      project_count: projects_json_array.size,
      projects_list: projects_json_array,
      status: 200,
      result: 'OK',
    }
    # TODO ここにDB登録する用のメソッド追加(共通メソッドにする)
    render json: response_json
  end
end
