# frozen_string_literal: true

# class_type: Service
# class_name: ProjectService
# description: common class for projects
class ProjectService
  class << self
    # get project_list
    def project_list(page, sort, search_query)
      pjt_list = []
      # offset
      offset = (page.to_i - 1) * Settings.pjt_list_count
      # 一覧検索
      pjts = []
      if search_query.blank?
        pjts = Project.project_list offset, sort
      else
        if search_query[:location_list].present?
          search_query[:location_list] = compose_location_id_list search_query[:location_list]
        end

        if search_query[:contract_list].present?
          search_query[:contract_list] = compose_contract_id_list search_query[:contract_list]
        end

        if search_query[:industry_list].present?
          search_query[:industry_list] = compose_industry_id_list search_query[:industry_list]
        end

        if search_query[:tag_list].present?
          search_query[:tag_list] = compose_tag_id_list search_query[:tag_list]
        end
        # 検索条件の分岐
        pjts = get_search_result offset, sort, search_query
      end

      if pjts.present?
        pjts.map do |pjt|
          pjt_hash = pjt.as_json
          pjt_list.push pjt_hash
        end
      end
      pjt_list
    end

    private

    # compose location id list
    def compose_location_id_list(location_name_list)
      location_id_list = []
      location_name_list.map do |location_name|
        locations = Location.select_location_id location_name
        locations.map { |location| location_id_list.push location.id }
      end
      location_id_list
    end

    # compose contract id list
    def compose_contract_id_list(contract_name_list)
      contract_id_list = []
      contract_name_list.map do |contract_name|
        contracts = Contract.select_contract_id contract_name
        contracts.map { |contract| contract_id_list.push contract.id }
      end
      puts "[INFO contract_id_list] #{contract_id_list}"
      contract_id_list
    end

    # compose industry id list
    def compose_industry_id_list(industry_name_list)
      industry_id_list = []
      industry_name_list.map do |industry_name|
        industries = Industry.select_industry_id industry_name
        industries.map { |industry| industry_id_list.push industry.id }
      end
      industry_id_list
    end

    # compose tag id list
    def compose_tag_id_list(tag_name_search_list)
      tag_id_list = []
      tag_name_search_list.map do |tag_name_search|
        tags = Tag.select_tag_id tag_name_search
        tags.map { |tag| tag_id_list.push tag.id }
      end
      tag_id_list
    end

    # FIXME ここの条件分岐を修正　よりシンプルに
    # FIX contractsのパラメータ時の挙動変かも
    def get_search_result(offset, sort, search_query)
      location = search_query[:locations_list]
      contract = search_query[:contract_list]
      industry = search_query[:industry_list]
      tag = search_query[:tag_list]

      if location.present? && contract.present? && industry.present? && tag.present?
        pjts = Project.project_list_search_all_tags offset, sort, search_query

      elsif location.present? && contract.present? && industry.present? && tag.blank?
        pjts = Project.project_list_search_location_contract_industry offset, sort, search_query
      elsif location.present? && contract.present? && industry.blank? && tag.present?
        pjts = Project.project_list_search_location_contract_tag offset, sort, search_query
      elsif location.present? && contract.blank? && industry.present? && tag.present?
        pjts = Project.project_list_search_location_industry_tag offset, sort, search_query
      elsif location.blank? && contract.present? && industry.present? && tag.present?
        pjts = Project.project_list_search_contract_industry_tag offset, sort, search_query

      elsif location.present? && contract.present? && industry.blank? && tag.blank?
        pjts = Project.project_list_search_location_contract offset, sort, search_query
      elsif location.present? && contract.blank? && industry.blank? && tag.present?
        pjts = Project.project_list_search_location_tag offset, sort, search_query
      elsif location.blank? && contract.blank? && industry.present? && tag.present?
        pjts = Project.project_list_search_industry_tag offset, sort, search_query
      elsif location.blank? && contract.present? && industry.present? && tag.blank?
        pjts = Project.project_list_search_contract_industry offset, sort, search_query

      elsif location.present? && contract.blank? && industry.blank? && tag.blank?
        pjts = Project.project_list_search_location offset, sort, search_query
      elsif location.blank? && contract.blank? && industry.blank? && tag.present?
        pjts = Project.project_list_search_tag offset, sort, search_query
      elsif location.blank? && contract.blank? && industry.present? && tag.blank?
        pjts = Project.project_list_search_industry offset, sort, search_query
      elsif location.blank? && contract.present? && industry.blank? && tag.blank?
        pjts = Project.project_list_search_contract offset, sort, search_query
      end
      pjts
    end
  end
end
