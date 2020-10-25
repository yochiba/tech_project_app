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
        # 案件の作成
        project = Project.create!(project_json[:create_json])
        result_flg = false if project.blank?
        # skill_tag & projectの紐付け
        if project.present?
          project_json[:skill_tag_array].map do |skill_tag|
            puts "#{skill_tag}"
            mid_skill_tag = MidSkillTag.create!(
              project_id: project.id,
              skill_tag_id: skill_tag[:skill_tag_id],
            )
            result_flg = false if mid_skill_tag.blank?
          end
        end 
      end
      result_flg
    end

    # スキルID判別メソッド
    def descriminate_skill_id(skill_tag_hash)
      # 既存のskill_tagを検索(複数件数取得されるためfirst使用)
      skill_tag = SkillTag.search_existing_skill_tag(skill_tag_hash[:skill_tag_name_search])
      skill_tag_id = skill_tag.present? ? skill_tag.first.id : 0
      if skill_tag.blank?
        # 該当しない場合は新たに追加
        new_skill_tag = SkillTag.create!(
          skill_tag_name: skill_tag_hash[:skill_tag_name],
          skill_tag_name_search: skill_tag_hash[:skill_tag_name_search],
          skill_type_id: skill_tag_hash[:skill_type_id],
        )
        skill_tag_id = new_skill_tag.id
      end
      skill_tag_id
    end

    # ロケーションID構成メソッド
    def compose_location_id(location)
      # FIXME
      location_id = 1
      location_id
    end

    # ポジションID構成メソッド
    def compose_position_id(position)
      # FIXME
      position_id = 1
      position_id
    end

    # 契約情報ID構成メソッド
    def compose_contract_id(contract)
      # FIXME
      contract_id = 1
      contract_id
    end
  end
end
