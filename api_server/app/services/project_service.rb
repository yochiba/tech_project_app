# frozen_string_literal: true

# class_type: Service
# class_name: ProjectService
# description: common class for projects
class ProjectService
  class << self
    # get project_list
    def project_list(params)
      page = params[:page]
      sort = params[:sort]
      pjt_list = []
      # offset
      offset = (page.to_i - 1) * Settings.pjt_list_count
      # location, contract, industry, tagを構成
      search_hash = compose_search_hash params 
      # 一覧検索
      pjts = []
      if search_hash[:search_type].blank?
        pjts = Project.project_list sort, offset
      else
        # 検索条件の分岐
        pjts = extract_search_query sort, offset, search_hash
      end
      pjts.map { |pjt| pjt_list.push pjt.as_json } if pjts.present?
      pjt_list
    end

    private

    # compose name_list_query
    def compose_search_hash(params)
      search_hash = {
        search_type: [],
      }

      if params[:locations].present?
        search_hash[:location_list] = compose_column_id_list params[:locations].split(','), 0
        search_hash[:search_type].push 0
      end
  
      if params[:contracts].present?
        search_hash[:contract_list] = compose_column_id_list params[:contracts].split(','), 1
        search_hash[:search_type].push 1
      end
  
      if params[:industries].present?
        search_hash[:industry_list] = compose_column_id_list params[:industries].split(','), 2
        search_hash[:search_type].push 2
      end
  
      if params[:tags].present?
        search_hash[:tag_list] = compose_column_id_list params[:tags].split(','), 3
        search_hash[:search_type].push 3
      end
      search_hash
    end

    # compose column id list
    def compose_column_id_list(column_name_list, search_type)
      column_id_list = []
      column_name_list.map do |column_name|
        search_result = []
        case search_type
        when Settings.search.type.location
          search_result = Location.select_location_id column_name
        when Settings.search.type.contract
          search_result = Contract.select_contract_id column_name
        when Settings.search.type.industry
          search_result = Industry.select_industry_id column_name
        when Settings.search.type.tag
          search_result = Tag.select_tag_id column_name
        end
        search_result.map { |result| column_id_list.push result.id }
      end
      column_id_list
    end

    # extract search query
    def extract_search_query(sort, offset, search_hash)
      search_type = search_hash[:search_type]
      pjts = []
      case search_type
      when Settings.search.type_list.all
        pjts = Project.project_list_search_all_tags sort, offset, search_hash
      when Settings.search.type_list.location_contract_industry
        pjts = Project.project_list_search_location_contract_industry sort, offset, search_hash
      when Settings.search.type_list.contract_industry_tag
        pjts = Project.project_list_search_contract_industry_tag sort, offset, search_hash
      when Settings.search.type_list.location_industry_tag
        pjts = Project.project_list_search_location_industry_tag sort, offset, search_hash
      when Settings.search.type_list.location_contract_tag
        pjts = Project.project_list_location_contract_tag sort, offset, search_hash
      when Settings.search.type_list.location_contract
        pjts = Project.project_list_search_location_contract sort, offset, search_hash
      when Settings.search.type_list.contract_industry
        pjts = Project.project_list_search_contract_industry sort, offset, search_hash
      when Settings.search.type_list.industry_tag
        pjts = Project.project_list_search_industry_tag sort, offset, search_hash
      when Settings.search.type_list.location_tag
        pjts = Project.project_list_search_location_tag sort, offset, search_hash
      when Settings.search.type_list.location
        pjts = Project.project_list_search_location sort, offset, search_hash
      when Settings.search.type_list.contract
        pjts = Project.project_list_search_contract sort, offset, search_hash
      when Settings.search.type_list.industry
        pjts = Project.project_list_search_industry sort, offset, search_hash
      when Settings.search.type_list.tag
        pjts = Project.project_list_search_tag sort, offset, search_hash
      end
      pjts
    end
  end
end
