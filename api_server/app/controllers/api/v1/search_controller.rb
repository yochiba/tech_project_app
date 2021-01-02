# frozen_string_literal: true

# controller for search
class Api::V1::SearchController < ApplicationController
  # GET index
  def index
    pjt_list_json = SearchService.project_list_json params
    res_json = ResponseService.pjts_list_search_result_json pjt_list_json
    render json: res_json
  end

  # GET show
  def show
    pjt_json = SearchService.project_json params[:pjtId]
    res_json = ResponseService.pjt_json pjt_json
    render json: res_json
  end

  # GET checkbox items
  def checkbox_items
    checkbox_items_json = SearchService.compose_checkbox_items
    res_json = ResponseService.checkbox_items_result_json checkbox_items_json
    render json: res_json
  end
end
