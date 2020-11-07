# frozen_string_literal: true

# class_type: Service
# class_name: ProjectService
# description: common class for DB operation for projects
class ProjectService
  # 空文字
  NO_SPACE = Settings.no_space
  # 全角英数字
  UPPER_CASE = Settings.uppercase
  # 半角英数字
  LOWER_CASE = Settings.lowercase
  # 全角スペース
  UPPER_SPACE = Settings.upper_space
  # 半角スペース
  LOWER_SPACE = Settings.lower_space
  # 全角数字
  UPPER_NUMS = Settings.upper_numbers
  # 半角数字
  LOWER_NUMS = Settings.lower_numbers

  # プログラミング言語
  LANGUAGE_TITLE_ARRAY = [
    'プログラミング言語',
  ].freeze
  # フレームワーク
  FRAMEWORK_TITLE_ARRAY = [
    'フレームワーク',
  ].freeze
  # データベース
  DATABASE_TITLE_ARRAY = [
    'データベース',
  ].freeze
  # ツール
  TOOL_TITLE_ARRAY = [
    'ツール',
  ].freeze
  # OS
  OS_TITLE_ARRAY = [
    'OS',
  ].freeze
  # パッケージ類
  PACKAGE_TITLE_ARRAY = [
    'サーバ基盤・パッケージ',
  ].freeze

  # 円/月に変換する単位
  YEN_PER_MONTH_ARRAY = [
    '万円/月',
  ].freeze

  # 稼働時間 時間
  HOUR_ARRAY = [
    '時間',
  ].freeze

  class << self
    # 案件登録メソッド
    def compose_project_json(project_json_array)
      result_flg = true
      project_json_array.map do |project_json|
        Rails.logger.info "[TARGET CREATE URL]:: #{project_json[:create_json][:url]}"
        # 案件の作成
        project = Project.create(project_json[:create_json])
        if project.blank?
          result_flg = false
          return result_flg
        end
        skill_tag_array = project_json[:skill_tag_array]
        position_array = project_json[:position_array]
        # skill_tag & projectの紐付け
        if skill_tag_array.present?
          result_flg = compose_mid_skill_tag project, skill_tag_array
        end
        # position & projectの紐付け
        if position_array.present?
          result_flg = compose_mid_position project, position_array
        end
      end
      result_flg
    end

    # スキルタイプ判別メソッド
    def descriminate_skill_type(skill_type_name)
      skill_type_id = 0
      case skill_type_name
      when *LANGUAGE_TITLE_ARRAY
        skill_type_id = Settings.skill_type.language
      when *FRAMEWORK_TITLE_ARRAY
        skill_type_id = Settings.skill_type.framework
      when *DATABASE_TITLE_ARRAY
        skill_type_id = Settings.skill_type.db
      when *TOOL_TITLE_ARRAY
        skill_type_id = Settings.skill_type.tool
      when *OS_TITLE_ARRAY
        skill_type_id = Settings.skill_type.os
      when *PACKAGE_TITLE_ARRAY
        skill_type_id = Settings.skill_type.package
      else
        # FIXME 仕様が決まってきてから番号を決める
        skill_type_id = 1000
      end
      skill_type_id
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

    # ポジション構成メソッド
    def compose_position(position_html_array)
      position_array = []
      position_html_array.map do |position_html|
        position = position_html.text
        # ポジション名称検索用(全角,大文字,空白なし)
        search_name = position.upcase.tr(UPPER_CASE, LOWER_CASE)
        # 空白が存在する場合
        search_name.gsub!(UPPER_SPACE, NO_SPACE) if search_name.include?(UPPER_SPACE)
        search_name.gsub!(LOWER_SPACE, NO_SPACE) if search_name.include?(LOWER_SPACE)
        position_hash = {
          position_name: position,
          position_name_search: search_name,
        }
        position_hash[:position_id] = compose_position_id(position_hash)
        position_array.push position_hash
      end
      position_array
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

    # 契約情報ID構成メソッド
    def compose_contract_id(contract_name)
      # 既存のデータに存在しないかを確認する
      contract = Contract.find_by(contract_name: contract_name)
      contract = Contract.create!(contract_name: contract_name) if contract.blank?
      contract.id
    end

    # 単価単位ID判別メソッド
    def descriminate_price_unit_id(price_unit_name)
      price_unit_id = 0
      case price_unit_name
      when *YEN_PER_MONTH_ARRAY
        price_unit_id = Settings.price_unit_id.yen_per_month
      else
        # FIXME 仕様が決まってきてから番号を決める
        price_unit_id = 100
      end
      {
        price_unit_id: price_unit_id,
        price_unit: price_unit_name,
      }
    end

    # 稼働単位ID判別メソッド
    def descriminate_ope_unit_id(ope_unit_name)
      ope_unit_id = 0
      case ope_unit_name
      when *HOUR_ARRAY
        ope_unit_id = Settings.operation_unit_id.hour
      else
        ope_unit_id = 100
      end
      {
        operation_unit_id: ope_unit_id,
        operation_unit: ope_unit_name,
      }
    end

    private

    # ポジションID構成メソッド
    def compose_position_id(position_hash)
      position_name = position_hash[:position_name]
      search_name = position_hash[:position_name_search]
      # 既存のデータに存在しないかを確認する
      position = Position.find_by(position_name_search: search_name)
      if position.blank?
        position = Position.create!(
          position_name: position_name,
          position_name_search: search_name,
        )
      end
      position.id
    end

    # mid_skill_tags構成メソッド
    def compose_mid_skill_tag(project, skill_tag_array)
      result_flg = true
      skill_tag_array.map do |skill_tag|
        mid_skill_tag = project.mid_skill_tags.create!(
          skill_tag_id: skill_tag[:skill_tag_id],
        )
        result_flg = false if mid_skill_tag.blank?
      end
      result_flg
    end

    # mid_position構成メソッド
    def compose_mid_position(project, position_array)
      result_flg = true
      position_array.map do |position|
        mid_position = project.mid_positions.create!(
          position_id: position[:position_id],
        )
        result_flg = false if mid_position.blank?
      end
      result_flg
    end
  end
end
