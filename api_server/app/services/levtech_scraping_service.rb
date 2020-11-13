# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'

# class_type: Service
# class_name: LevtechScrapingService
# description: scraping class for Midworks
class LevtechScrapingService
  # ホストURL
  HOST_URL = Settings.levtech.url.host
  # 新着案件URL
  NEW_PROJECTS_URL = Settings.levtech.url.new_projects
  # 東京都の案件
  AREA_TOKYO = '/pref-13'
  # FIXME 取得する最大ページ数
  MAX_PAGE_COUNT = 1
  # 1ページの表示件数
  PROJECTS_PER_PAGE = 40
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

  class << self
    # scraping service for levtech
    def scraping_root
      Rails.logger.info "[SCRAPING START]:: LevtechScrapingService"
      # 総案件数を取得するためのリクエスト
      url = "#{NEW_PROJECTS_URL}#{AREA_TOKYO}"
      new_projects_page_html = Nokogiri::HTML.parse(open(url, allow_redirections: :all))
      # 総案件数からページ数取得
      total_projects = new_projects_page_html.css('.search__result__summary span').text.to_i
      page_count = total_projects / PROJECTS_PER_PAGE
      page_count_array = page_count >= MAX_PAGE_COUNT ? [*1..MAX_PAGE_COUNT] : [*1..page_count]
      # 案件情報json作成
      project_json_array = request_project_list page_count_array
      Rails.logger.info "[SCRAPING END]:: LevtechScrapingService"
      project_json_array
    end

    private

    # 案件情報一覧リクエストメソッド
    def request_project_list(page_count_array)
      project_json_array = []
      page_count_array.map do |page|
        begin
          page_param = page == 1 ? "#{AREA_TOKYO}" : "#{AREA_TOKYO}/p#{page}"
          url = "#{NEW_PROJECTS_URL}#{page_param}"
          project_list_html = Nokogiri::HTML.parse(open(url, allow_redirections: :all))
        rescue => exception
          Rails.logger.info exception
        end
        project_json_array = compose_project_json_array project_json_array, project_list_html
        sleep 5
      end
      project_json_array
    end

    # 案件情報json配列構成メソッド
    def compose_project_json_array(project_json_array, project_list_html)
      project_id_array = project_list_html.css('.prjHead__ttl a')
      project_id_array.map do |project_id|
        project_url = "#{HOST_URL}#{project_id[:href]}"
        project_hash = compose_project(project_url)
        # エラー案件の場合はスキップ
        next if project_hash[:error_project]
        project_json_array.push project_hash
        sleep 2
      end
      project_json_array
    end

    # 各案件の情報を構成
    def compose_project(url)
      begin
        Rails.logger.info "[SCRAPING TARGET URL]:: #{url}"
        project_html = Nokogiri::HTML.parse(open(url, allow_redirections: :all))
      rescue => exception
        Rails.logger.info exception
      end
      # 案件データ格納ハッシュ
      project_hash = {
        create_json: {
          company: Settings.levtech.company_name,
          company_id: Settings.levtech.company_id,
          url: url,
        },
        error_project: false,
      }
      project_html = project_html.css('.pjt')
      # puts "[PROJECT DETAIL]:: #{project_html}"
      # 案件名称
      project_title = compose_project_title project_html, project_hash
      # TODO 本番稼働時には下記を起動
      # # 案件検索
      # existing_project = Project.find_by(title: project_title)
      # # 案件検索の結果、すでに存在する場合
      # if existing_project.present?
      #   project_hash[:error_project] = true
      #   return project_hash
      # end
      # 案件の概要：単価、契約形態、ポジション、最寄り駅
      summary_html = project_html.css('.pjtSummary')
      compose_summary summary_html, project_hash
      # detail
      detail_html_array = project_html.css('.pjtDetail__row')
      descriminate_detail detail_html_array, project_hash
      project_hash
    end

    # 案件名称構成メソッド
    def compose_project_title(project_html, project_hash)
      # 案件名称
      project_title = project_html.css('.pjt__ttl').text
      # 案件名称が存在しない場合
      if project_title.blank?
        project_hash[:error_project] = true
        return project_hash
      end
      project_title.gsub!(/[\r\n]/, Settings.no_space)
      project_title.gsub!('New', Settings.no_space) if project_title.include?('New')
      project_hash[:create_json][:title] = project_title
      project_title
    end

    # 概要構成メソッド
    def compose_summary(summary_html, project_hash)
      summary_row_array = summary_html.css('.pjtSummary__row')
      summary_row_array.map do |summary_row|
        title = summary_row.css('.pjtSummary__row__ttl').text
        if title.include?(Settings.levtech.title.price)
          title = title.slice!(Settings.levtech.title.price)
        end
        # 概要判別
        case title
        when Settings.levtech.title.price
          compose_price summary_row, project_hash
        when Settings.levtech.title.position
          compose_position summary_row, project_hash
        when Settings.levtech.title.contract_location
          compose_contract_location summary_row, project_hash
        end
      end
    end

    # 案件単価構成メソッド
    def compose_price(summary_row, project_hash)
      price_class = '.pjtSummary__row__desc'
      # 最大単価
      price = summary_row.css("#{price_class} .js-yen").text.gsub!(',', Settings.no_space).to_i
      project_hash[:create_json][:max_price] = price
      # 単価単位
      price_unit_name = summary_row.css(price_class).text.gsub!(/[\r\n]|,|〜|[\d]|収益シミュレーションを見る|（収支シミュレーション）/, '')
      # '円円／◯◯'で取得されてしまう場合
      price_unit_name.gsub!('円円', '円') if price_unit_name.include?('円円')
      project_hash[:create_json].merge! ProjectService.descriminate_price_unit_id price_unit_name
    end

    # 職種・ポジション構成メソッド
    def compose_position(summary_row, project_hash)
      position_class = '.pjtSummary__row__desc.pjtSummary__row__desc--tag a'
      position_html_array = summary_row.css(position_class)
      project_hash[:position_array] = ProjectService.compose_position_array position_html_array
    end

    # 契約情報構成メソッド
    def compose_contract_location(summary_row, project_hash)
      row_array = summary_row.css('.pjtSummary__row__desc')
      row_array.map.with_index do |row, index|
        row_name = row.text
        if index.zero?
          project_hash[:contract_name] = row_name.gsub!(/[\r\n]/, Settings.no_space)
          project_hash[:create_json][:contract_id] = ProjectService.compose_contract_id(row_name)
        else
          project_hash[:location_name] = row_name
          project_hash[:create_json][:location_id] = ProjectService.compose_location_id(row_name)
        end
      end
    end

    # 案件詳細判別メソッド
    def descriminate_detail(detail_html_array, project_hash)
      detail_html_array.map do |detail_html|
        title = detail_html.css('.pjtDetail__row__ttl').text
        case title
        when Settings.levtech.title.description
          compose_descripton detail_html, project_hash
        when Settings.levtech.title.skill
          compose_skill detail_html, project_hash
        when Settings.levtech.title.skill_tags
          compose_skill_tags detail_html, project_hash
        else
          break
        end
      end
    end

    # 業務内容構成メソッド
    def compose_descripton(detail_html, project_hash)
      description = detail_html.css('p')[1].text
      project_hash[:create_json][:description] = description if description.present?      
    end

    # スキル構成メソッド
    def compose_skill(detail_html, project_hash)
      skill_array = detail_html.css('.descDetail__txt')
      # 必須スキル
      if skill_array[0].present?
        required_skills = skill_array[0].text
        project_hash[:create_json][:required_skills] = required_skills
      end
      # 歓迎スキル
      if skill_array[2].present?
        other_skills = skill_array[2].text
        project_hash[:create_json][:other_skills] = other_skills
      end
    end

    # スキルタグ構成メソッド
    def compose_skill_tags(detail_html, project_hash)
      skill_tags_html_array = detail_html.css('.pjtDetail__row__desc .descDetail')
      skill_tags_array = []
      skill_tags_html_array.map do |skill_tag_html|
        discriminate_skills skill_tag_html, skill_tags_array
      end
      project_hash[:skill_tag_array] = skill_tags_array
    end

    # スキル判別メソッド
    def discriminate_skills(skill_tag_html, skill_tags_array)
      skill_type_name = skill_tag_html.css('.descDetail__ttl').text
      # スキルタグ名称配列
      skill_tag_name_html_array = skill_tag_html.css('.descDetail__txt .pjtTag')
      skill_tag_name_html_array.map do |skill_tag_name_html|
        skill_tag_name = skill_tag_name_html.text
        next if skill_tag_name.blank?
        # スキル名称検索用(全角,大文字,空白なし)
        search_name = skill_tag_name.upcase.tr(UPPER_CASE, LOWER_CASE)
        # 空白が存在する場合
        search_name.gsub!(UPPER_SPACE, NO_SPACE) if search_name.include?(UPPER_SPACE)
        search_name.gsub!(LOWER_SPACE, NO_SPACE) if search_name.include?(LOWER_SPACE)
        # スキルタイプ判別
        skill_type_id = ProjectService.descriminate_skill_type skill_type_name
        # skillハッシュ
        skill_tag_hash = {
          skill_type_name: skill_type_name,
          skill_type_id: skill_type_id,
          skill_tag_name: skill_tag_name,
          skill_tag_name_search: search_name,
        }
        # 既存スキルタグの判別と新規作成
        skill_tag_hash[:skill_tag_id] = ProjectService.descriminate_skill_id skill_tag_hash
        skill_tags_array.push skill_tag_hash
      end
      skill_tags_array
    end
  end
end
