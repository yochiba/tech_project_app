# frozen_string_literal: true

# controller for project
class Api::V1::ProjectsController < ApplicationController
  def index
    project_list = ProjectService.project_list params[:page]
    response_json = {
      count: project_list.size,
      project_list: project_list,
      result: project_list.present? ? 'OK' : 'NOT FOUND',
      status: project_list.present? ? 200 : 404,
    }
    render json: response_json
  end
end
