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
        project = Project.create!(project_json[:create_json])
        result_flg = false if project.blank?
        # skill_tag & projectの紐付け
        if project.present? && project_json[:skill_tag_array].present?
          project_json[:skill_tag_array].map do |skill_tag|
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

# FIXME ここから
    # midworks_scraping_serviceでは、下記4テーブルの登録は行わない。
    # 上記のcompose_project_jsonメソッドを呼び出して、projectsをcreateして
    # その後にprivateメソッド(下記4メソッドのような)でcreate処理を行う

    # ロケーションID構成メソッド
    def compose_location_id(location_name)
      # FIXME 検索条件を検討
      location = Location.find_by(location_name: location_name)
      location = Location.create!(location_name: location_name) if location.blank?
      location_id = location.id
      location_id
    end

    # ポジションID構成メソッド
    def compose_position_id(position_name)
      # FIXME 検索条件を検討
      position = Position.find_by(position_name: position_name)
      position = Position.create!(position_name: position_name) if position.blank?
      position_id = position.id
      position_id
    end

    # 業界ID構成メソッド
    def compose_industry_id(industry_name)
      # FIXME 検索条件を検討
      industry = Industry.find_by(industry_name: industry_name)
      industry = Industry.create!(industry_name: industry_name) if industry.blank?
      industry_id = industry.id
      industry_id
    end

    # 契約情報ID構成メソッド
    def compose_contract_id(contract_name)
      # FIXME 検索条件を検討
      contract = Contract.find_by(contract_name: contract_name)
      contract = Contract.create!(contract_name: contract_name) if contract.blank?
      contract_id = contract.id
      contract_id
    end

# FIXME ここまで

    # スキルID判別メソッド
    def descriminate_skill_id(skill_tag_hash)
      # 完全一致で検索
      skill_tag = SkillTag.find_by(skill_tag_name_search: skill_tag_hash[:skill_tag_name_search])
      # 完全一致しなかった場合にLIKE検索
      if skill_tag.blank?
        # 既存のskill_tagを検索(複数件数取得されるためfirst使用)
        skill_tag = SkillTag.search_existing_skill_tag(skill_tag_hash[:skill_tag_name_search])
      end
      skill_tag_id = skill_tag.present? ? skill_tag.first.id : 0
      if skill_tag.blank?
        # 該当しない場合: 新規追加
        new_skill_tag = SkillTag.create!(
          skill_tag_name: skill_tag_hash[:skill_tag_name],
          skill_tag_name_search: skill_tag_hash[:skill_tag_name_search],
          skill_type_id: skill_tag_hash[:skill_type_id],
        )
        skill_tag_id = new_skill_tag.id
      end
      skill_tag_id
    end
  end
end
