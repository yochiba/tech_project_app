# frozen_string_literal: true

# controller for scraping
class ScrapingController < ApplicationController
  def scrape_midworks
    projects_array = MidworksScrapingService.compose_projects_json
    # 下記のJsonは仮置き
    response_json = {
      project_count: projects_array.size,
      projects_list: projects_array,
      status: 200,
      result: 'OK',
    }
    # TODO ここにDB登録する用のメソッド追加(共通メソッドにする)
    render json: response_json
  end
end
