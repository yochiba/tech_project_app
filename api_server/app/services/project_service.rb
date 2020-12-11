# frozen_string_literal: true

# class_type: Service
# class_name: ProjectService
# description: common class for projects
class ProjectService
  LOCATION_TYPE = Settings.search.type.location
  CONTRACT_TYPE = Settings.search.type.contract
  INDUSTRY_TYPE = Settings.search.type.industry
  POSITION_TYPE = Settings.search.type.position
  TAG_TYPE = Settings.search.type.tag

  class << self
    # get project_list
    def project_list(params)
      page = params[:page]
      sort = params[:sort]
      pjt_list = []
      # offset
      offset = (page.to_i - 1) * Settings.pjt_list_count
      # location, contract, industry, tagを2構成
      search_hash = compose_search_conditions_hash params
      # 一覧検索
      pjts = []
      if search_hash[:search_type].blank?
        pjts = Project.project_list sort, offset
      else
        pjts = execute_search_query sort, offset, search_hash
      end
      pjts.map { |pjt| pjt_list.push pjt.as_json } if pjts.present?
      pjt_list
    end

    private

    # compose search conditions hash
    def compose_search_conditions_hash(params)
      search_hash = {
        search_type: [],
      }

      if params[:locations].present?
        location_list = compose_column_id_list params[:locations].split(','), LOCATION_TYPE
        search_hash[:location_list] = location_list
        search_hash[:search_type].push LOCATION_TYPE
      end

      if params[:contracts].present?
        contract_list = compose_column_id_list params[:contracts].split(','), CONTRACT_TYPE
        search_hash[:contract_list] = contract_list
        search_hash[:search_type].push CONTRACT_TYPE
      end

      if params[:industries].present?
        industry_list = compose_column_id_list params[:industries].split(','), INDUSTRY_TYPE
        search_hash[:industry_list] = industry_list
        search_hash[:search_type].push INDUSTRY_TYPE
      end

      if params[:positions].present?
        position_list = compose_column_id_list params[:positions].split(','), POSITION_TYPE
        search_hash[:position_list] = position_list
        search_hash[:search_type].push POSITION_TYPE
      end

      if params[:tags].present?
        tag_list = compose_column_id_list params[:tags].split(','), TAG_TYPE
        search_hash[:tag_list] = tag_list
        search_hash[:search_type].push TAG_TYPE
      end
      search_hash
    end

    # compose column id list
    def compose_column_id_list(column_name_list, search_type)
      column_id_list = []
      column_name_list.map do |column_name|
        search_result = []
        case search_type
        when LOCATION_TYPE
          search_result = Location.select_location_id column_name
        when CONTRACT_TYPE
          search_result = Contract.select_contract_id column_name
        when INDUSTRY_TYPE
          search_result = Industry.select_industry_id column_name
        when POSITION_TYPE
          search_result = Position.select_position_id column_name
        when TAG_TYPE
          search_result = Tag.select_tag_id column_name
        end
        search_result.map { |result| column_id_list.push result.id }
      end
      column_id_list
    end

    # execute search query
    def execute_search_query(sort, offset, search_hash)
      search_type_list = search_hash[:search_type]
      search_query = Project.project_list_select.project_list_left_outer_joins

      search_type_list.map do |search_type|
        case search_type
        when LOCATION_TYPE
          search_query.merge! Project.where_location_id_in search_hash[:location_list]
        when CONTRACT_TYPE
          search_query.merge! Project.where_contract_id_in search_hash[:contract_list]
        when INDUSTRY_TYPE
          search_query.merge! Project.where_industry_id_in search_hash[:industry_list]
        when POSITION_TYPE
          search_query.merge! Project.where_position_id_in search_hash[:position_list]
        when TAG_TYPE
          search_query.merge! Project.where_tag_id_in search_hash[:tag_list]
        end
      end
      search_query.merge! Project.project_list_accessories sort, offset
      pjts = ActiveRecord::Base.connection.select_all search_query.to_sql
      pjts
    end
  end
end
