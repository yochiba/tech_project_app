# frozen_string_literal: true

# class_type: Service
# class_name: SearchService
# description: common class for search
class SearchService
  # project list count
  PJT_LIST_COUNT = Settings.pjt_list_count

  # column type numbers
  LOCATION_TYPE = Settings.search.type.location
  CONTRACT_TYPE = Settings.search.type.contract
  INDUSTRY_TYPE = Settings.search.type.industry
  POSITION_TYPE = Settings.search.type.position
  TAG_TYPE = Settings.search.type.tag

  class << self
    # get project json
    def project_json(pjt_id)
      pjt = Project.single_project(pjt_id.to_i)
      # GROUP_CONCATで取得した文字列を配列化
      compose_name_list pjt
      pjt_json = pjt.as_json
      pjt_json
    end

    # get project_list_json
    def project_list_json(params)
      puts "[INFO PARAMS]:: #{params}"
      page = params[:page].to_i
      sort = params[:sort]
      # location, contract, industry, tagを構成
      search_hash = compose_search_conditions_hash params
      # 検索
      project_json = execute_search_query sort, page, search_hash
      project_json
    end

    def compose_checkbox_items
      tags = Tag.select_tags
      locations = Location.select_locations
      contracts = Contract.select_contracts
      positions = Position.select_positions
      industries = Industry.select_industries

      checkbox_items_json = {
        tagList: tags,
        locationList: locations,
        contractList: contracts,
        positionList: positions,
        industryList: industries,
      }
      checkbox_items_json
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
    def execute_search_query(sort, page, search_hash)
      # offset
      offset = (page - 1) * PJT_LIST_COUNT

      pjt_hash_list = []
      total_pjts = 0
      if search_hash[:search_type].blank?
        pjt_hash_list = Project.select_option.project_list.sub_options sort, offset
        total_pjts_query = Project.select_total_count.project_list.group('projects.id')
        total_pjts = total_pjts_query.as_json.size
      else
        search_type_list = search_hash[:search_type]
        search_query = Project.project_list_left_outer_joins
        # 検索クエリ作成
        compose_search_query search_type_list, search_query, search_hash
        # 総件数取得
        total_pjts_query = search_query.merge Project.select_total_count.group('projects.id')
        total_pjts = total_pjts_query.as_json.size
        # 案件データ取得
        search_query.merge! Project.select_option
        search_query.merge! Project.sub_options sort, offset
        pjt_hash_list = ActiveRecord::Base.connection.select_all search_query.to_sql
      end

      pjt_list = []
      if pjt_hash_list.present?
        pjt_hash_list.map do |pjt|
          # GROUP_CONCATで取得した文字列を配列化
          compose_name_list pjt
          pjt_list.push pjt.as_json
        end
      end

      # 総ページ数を取得
      total_pages = compose_total_pages total_pjts
      project_json = {
        current_page: page,
        total_pages: total_pages,
        total_pjt_count: total_pjts,
        sort: sort,
        pjt_count: pjt_list.size,
        pjt_list: pjt_list,
      }
      project_json
    end

    # 検索クエリ作成
    def compose_search_query(search_type_list, search_query, search_hash)
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
    end

    # compose name list
    def compose_name_list(pjt)
      if pjt['position_name_list'].present?
        position_name_list = pjt['position_name_list']
        pjt['position_name_list'] = position_name_list.split(',')
      end

      if pjt['position_name_search_list'].present?
        position_name_search_list = pjt['position_name_search_list']
        pjt['position_name_search_list'] = position_name_search_list.split(',')
      end

      if pjt['industry_name_list'].present?
        industry_name_list = pjt['industry_name_list']
        pjt['industry_name_list'] = industry_name_list.split(',')
      end

      if pjt['industry_name_search_list'].present?
        industry_name_search_list = pjt['industry_name_search_list']
        pjt['industry_name_search_list'] = industry_name_search_list.split(',')
      end

      if pjt['tag_name_list'].present?
        tag_name_list = pjt['tag_name_list']
        pjt['tag_name_list'] = tag_name_list.split(',')
      end

      if pjt['tag_name_search_list'].present?
        tag_name_search_list = pjt['tag_name_search_list']
        pjt['tag_name_search_list'] = tag_name_search_list.split(',')
      end
    end

    # 総ページ数
    def compose_total_pages(total_pjts)
      total_pages = total_pjts / PJT_LIST_COUNT
      if total_pjts <= PJT_LIST_COUNT && total_pjts != 0
        total_pages = 1
      elsif total_pjts % PJT_LIST_COUNT != 0
        total_pages += 1
      elsif total_pjts.zero?
        total_pages = 0
      end
      total_pages
    end
  end
end
