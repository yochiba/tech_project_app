# frozen_string_literal: true

# controller for project
class Api::V1::ProjectsController < ApplicationController
  # GET index
  def index
    puts "[QUERY INFO]:: #{params.as_json}"
    pjt_list = ProjectService.project_list params[:page], params[:sort], params[:search_query]
    response_json = {
      count: pjt_list.size,
      project_list: pjt_list,
      result: pjt_list.present? ? Settings.response.ok.result : Settings.response.not_found.result,
      status: pjt_list.present? ? Settings.response.ok.status : Settings.response.not_found.status,
    }
    render json: response_json
  end
end
