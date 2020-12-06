# frozen_string_literal: true

# controller for project
class Api::V1::ProjectsController < ApplicationController
  # GET index
  def index
    search_query = compose_search_query params
    pjt_list = ProjectService.project_list params[:page], params[:sort], search_query
    response_json = {
      count: pjt_list.size,
      project_list: pjt_list,
      result: pjt_list.present? ? Settings.response.ok.result : Settings.response.not_found.result,
      status: pjt_list.present? ? Settings.response.ok.status : Settings.response.not_found.status,
    }
    render json: response_json
  end

  private

  def compose_search_query(params)
    search_query = {}
    if params[:locations].present?
      search_query[:location_list] = params[:locations].split(',')
    end

    if params[:contracts].present?
      puts "[INFO CONTRACT]:: #{params[:contracts]}"
      search_query[:contract_list] = params[:contracts].split(',')
    end

    if params[:industries].present?
      puts "[INFO INDUSTRY]:: #{params[:industries]}"
      search_query[:industry_list] = params[:industries].split(',')
    end

    if params[:tags].present?
      search_query[:tag_list] = params[:tags].split(',')
    end
    search_query
  end
end
