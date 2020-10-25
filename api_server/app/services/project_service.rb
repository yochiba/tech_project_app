# frozen_string_literal: true

# class_type: Service
# class_name: ProjectService
# description: common class for DB operation for projects
class ProjectService
  class << self

    # 案件登録メソッド
    def compose_project_json(project_json_array)
      project_json_array.map do |project_json|
        # 案件の作成
        project = Project.create!(project_json[:create_json])
        # skill_tag & projectの紐付け
        if project.present?
          project_json[:skill_tag_array].map do |skill_tag|
            MidSkillTag.create!(
              project_id: project.id,
              skill_tag_id: skill_tag[:skill_tag_id],
            )
          end
        end
      response_json = {
        status: 200
      }
      response_json
      end
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

    private

    # 案件情報をDBに登録
    def create_project(project_json)

      project = Project.create!(project_json)
      puts "[INFO]:: #{project.to_json}"
      response_json = {}
      # project_json_array.map do |project_json|
      #   puts "[INFO]:: #{project_json[:title]}"
      #   # FIXME, 下記の作成内容を作り替え
      #   project = Project.create!(
      #     title: project_json[:title],
      #     description: project_json[:description],
      #     company_id: project_json[:company_id],
      #     url: project_json[:url],
      #     required_skills: project_json[:required_skills],
      #     other_skills: project_json[:other_skills],
      #     weekly_attendance: project_json[:weekly_attendance],
      #     min_operation_unit: project_json[:operation][:min],
      #     max_operation_unit: project_json[:operation][:max],
      #     operation_unit_id: project_json[:operation][:unit_id],
      #     operation_unit: project_json[:operation][:unit_name],
      #     min_price: project_json[:price][:min],
      #     max_price: project_json[:price][:max],
      #     price_unit_id: project_json[:price][:unit_id],
      #     price_unit: project_json[:price][:unit_name],
      #     location_id: project_json[:location][:id],
      #     location: project_json[:location][:name],
      #     contract_id: project_json[:contract][:id],
      #     contract: project_json[:contract][:name],
      #     position_id: project_json[:position][:id],
      #     position: project_json[:position][:name],
      #   )
      
      # skill_tag & projectの紐付け
      if project.present?
        project_json[:skill_tags].map do |skill_tag|
          MidSkillTag.create!(
            project_id: project.id,
            skill_tsag_id: skill_tag[:skill_tag_id],
          )
        end
      end
      response_json = {
        status: 200
      }
      response_json
    end
  end
end
