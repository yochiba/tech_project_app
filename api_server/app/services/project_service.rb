# frozen_string_literal: true

# class_type: Service
# class_name: ProjectService
# description: common class for DB operation for projects
class ProjectService
  class << self
    # 案件登録メソッド
    def compose_project_json(project_json_array)
      result_flg = true
      project_json_array.map do |project_json|
        Rails.logger.info "[CREATE TARGET URL]:: #{project_json[:create_json][:url]}"
        # 案件の作成
        project = Project.create(project_json[:create_json])
        if project.blank?
          result_flg = false
          return result_flg
        end
        skill_tag_array = project_json[:skill_tag_array]
        # skill_tag & projectの紐付け
        if skill_tag_array.present?
          result_flg = compose_skill_tag project, skill_tag_array
        end
      end
      result_flg
    end

    # スキルタグ構成メソッド
    def compose_skill_tag(project, skill_tag_array)
      result_flg = true
      skill_tag_array.map do |skill_tag|
        mid_skill_tag = project.mid_skill_tags.create!(
          skill_tag_id: skill_tag[:skill_tag_id],
        )
        result_flg = false if mid_skill_tag.blank?
      end
      result_flg
    end

    # ロケーションID構成メソッド
    def compose_location_id(location_name)
      # 既存のデータに存在しないかを確認する
      location = Location.find_by(location_name: location_name)
      location = Location.create!(location_name: location_name) if location.blank?
      location.id
    end

    # 業界ID構成メソッド
    def compose_industry_id(industry_name)
      # 既存のデータに存在しないかを確認する
      industry = Industry.find_by(industry_name: industry_name)
      industry = Industry.create!(industry_name: industry_name) if industry.blank?
      industry.id
    end

    # ポジションID構成メソッド
    def compose_position_id(position_name)
      # 既存のデータに存在しないかを確認する
      position = Position.find_by(position_name: position_name)
      position = Position.create!(position_name: position_name) if position.blank?
      position.id
    end

    # 契約情報ID構成メソッド
    def compose_contract_id(contract_name)
      # 既存のデータに存在しないかを確認する
      contract = Contract.find_by(contract_name: contract_name)
      contract = Contract.create!(contract_name: contract_name) if contract.blank?
      contract.id
    end

    # スキルID判別メソッド
    def descriminate_skill_id(skill_tag_hash)
      # 完全一致で検索
      skill_tag = SkillTag.where(skill_tag_name_search: skill_tag_hash[:skill_tag_name_search])
      # 完全一致しなかった場合にLIKE検索
      if skill_tag.blank?
        skill_tag = SkillTag.search_existing_skill_tag(skill_tag_hash[:skill_tag_name_search])
      end
      # 複数件数取得(where)されるためfirst使用
      skill_tag_id = skill_tag.present? ? skill_tag.first.id : 0
      if skill_tag.blank?
        new_skill_tag = SkillTag.create!(skill_tag_hash)
        skill_tag_id = new_skill_tag.id
      end
      skill_tag_id
    end
  end
end
