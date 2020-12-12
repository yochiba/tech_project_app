# frozen_string_literal: true

# controller for project
class Api::V1::ProjectsController < ApplicationController
  # GET index
  def index
    # search_query = compose_search_query params
    pjt_json = ProjectService.project_list_json params
    res_json = ResponseService.pjts_list_search_result_json pjt_json
    render json: res_json
  end

  # GET show
  def show
    pjt_json = ProjectService.project_json(params[:id])
    res_json = ResponseService.pjt_json pjt_json
    render json: res_json
  end
end
