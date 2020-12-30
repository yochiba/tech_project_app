# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'

# class_type: Service
# class_name: PotepanScrapingService
# description: scraping class for Midworks
class PotepanScrapingService
  # ホストURL
  HOST_URL = Settings.potepan.url.host
  # 新着案件URL
  NEW_PROJECTS_URL = Settings.potepan.url.new_projects
  # 東京都の案件
  AREA_TOKYO = '/prefecture-1'
  # FIXME 取得する最大ページ数
  MAX_PAGE_COUNT = 2
  # 1ページの表示件数
  PROJECTS_PER_PAGE = 10
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
  # その他 文字列
  OTHER_STR = 'その他'

  class << self
    # scraping service for potepan
    def scraping_root
      Rails.logger.info "[SCRAPING START]:: PotepanScrapingService"
      # 総案件数を取得するためのリクエスト
      url = "#{NEW_PROJECTS_URL}#{AREA_TOKYO}"
      Rails.logger.info "[PROJECT LIST URL]:: #{url}"
      new_projects_page_html = Nokogiri::HTML.parse(open(url, allow_redirections: :all))
      # 総案件数からページ数取得
      page_class = '.project__wrapper .project__index-title p span'
      total_projects = new_projects_page_html.css(page_class).text.to_i
      page_count = total_projects / PROJECTS_PER_PAGE
      page_count_list = page_count >= MAX_PAGE_COUNT ? [*1..MAX_PAGE_COUNT] : [*1..page_count]
      # 案件情報json作成
      project_json_list = request_project_list page_count_list
      Rails.logger.info "[SCRAPING END]:: PotepanScrapingService"
      project_json_list
    end

    private

    # 案件情報一覧リクエストメソッド
    def request_project_list(page_count_list)
      project_json_list = []
      page_count_list.map do |page|
        begin
          url = "#{NEW_PROJECTS_URL}#{AREA_TOKYO}?page=#{page}"
          project_list_html = Nokogiri::HTML.parse(open(url, allow_redirections: :all))
        rescue => exception
          Rails.logger.info exception
        end
        project_json_list = compose_project_json_list project_json_list, project_list_html
        sleep 5
      end
      project_json_list
    end

    # 案件情報json配列構成メソッド
    def compose_project_json_list(project_json_list, project_list_html)
      project_id_list = project_list_html.css('.single-project__title')
      project_id_list.map do |project_id|
        project_url = "#{HOST_URL}#{project_id[:href]}"
        project_hash = compose_project project_url
        # エラー案件の場合はスキップ
        next if project_hash[:error_project]
        project_json_list.push project_hash
        sleep 2
      end
      project_json_list
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
          company: Settings.potepan.company_name,
          company_id: Settings.potepan.company_id,
          url: url,
          affiliate_url: Settings.potepan.url.affiliate_url,
        },
        error_project: false,
      }
      project_html = project_html.css('.single-project')
      # 案件名称
      project_title = compose_project_title project_html, project_hash
      # TODO 本番稼働時には下記を起動
      # 案件検索
      # existing_project = Project.find_by(title: project_title)
      # 案件検索の結果、すでに存在する場合
      # if existing_project.present?
      #   project_hash[:error_project] = true
      #   return project_hash
      # end

      # 案件単価
      compose_price project_html, project_hash
      # 詳細
      project_detail_list = project_html.css('.single-project__data-area dl')
      descriminate_detail_html project_detail_list, project_hash

      project_hash
    end

    # 案件名称構成メソッド
    def compose_project_title(project_html, project_hash)
      # 案件名称
      project_title = project_html.css('h3').text
      # 案件名称が存在しない場合
      if project_title.blank?
        project_hash[:error_project] = true
        return project_hash
      end
      project_title.gsub!(/[\r\n]/, NO_SPACE).lstrip!.rstrip!
      project_hash[:create_json][:title] = project_title
      project_title
    end

    # 案件単価構成メソッド
    def compose_price(project_html, project_hash)
      price_str = project_html.css('.single-project__price').text
      price_str.gsub!(/[\r\n]|~|,/, NO_SPACE).lstrip!.rstrip!
      # 最大単価
      max_price = price_str.gsub(/[^\d]/, NO_SPACE).to_i
      # 単価単位名称
      price_unit_name = price_str.gsub(/[\d]/, NO_SPACE)
      project_hash[:create_json][:max_price] = max_price
      project_hash[:create_json].merge! ScrapingService.descriminate_price_unit_id price_unit_name
    end

    # 案件詳細判別メソッド
    def descriminate_detail_html(detail_html_list, project_hash)
      detail_html_list.map do |detail_html|
        # 案件詳細情報の各項目のタイトルを取得
        detail_title = detail_html.css('dt').text
        next if detail_title.blank?
        case detail_title
        when Settings.potepan.title.description
          compose_description detail_html, project_hash
        when Settings.potepan.title.location
          compose_location detail_html, project_hash
        when Settings.potepan.title.required_skills
          compose_required_skills detail_html, project_hash
        when Settings.potepan.title.other_skills
          compose_other_skills detail_html, project_hash
        when Settings.potepan.title.environment
          compose_environment detail_html, project_hash
        when Settings.potepan.title.tags
          project_hash[:tag_list] = compose_tags detail_html, project_hash
        else
          next
        end
      end
    end

    # 業務内容構成メソッド
    def compose_description(detail_html, project_hash)
      description = detail_html.css('dd p').text
      project_hash[:create_json][:description] = description if description.present?
    end

    # 勤務地構成メソッド
    def compose_location(detail_html, project_hash)
      location = detail_html.css('dd p a').text
      if location.present?
        project_hash[:location_name] = location
        project_hash[:create_json][:location_id] = ScrapingService.compose_location_id(location)
      end
    end

    # 必須スキル構成メソッド
    def compose_required_skills(detail_html, project_hash)
      required_skills = detail_html.css('dd p').text
      project_hash[:create_json][:required_skills] = required_skills if required_skills.present?
    end

    # 尚可スキル構成メソッド
    def compose_other_skills(detail_html, project_hash)
      other_skills = detail_html.css('dd p').text
      project_hash[:create_json][:other_skills] = other_skills if other_skills.present?
    end

    # 開発環境構成メソッド
    def compose_environment(detail_html, project_hash)
      environment = detail_html.css('dd p').text
      project_hash[:create_json][:environment] = environment if environment.present?
    end

    # タグ構成メソッド
    def compose_tags(detail_html, project_hash)
      tags_html_list = detail_html.css('dd p a')
      tags_list = []
      tags_html_list.map do |tag_html|
        discriminate_tags tag_html, tags_list
      end
      project_hash[:tag_list] = tags_list
    end

    # タグ判別メソッド
    def discriminate_tags(tag_html, tags_list)
      tag_name = tag_html.text
      # タグ名称検索用(全角,大文字,空白なし)
      search_name = tag_name.upcase.tr(UPPER_CASE, LOWER_CASE)
      # 空白が存在する場合
      search_name.gsub!(UPPER_SPACE, NO_SPACE) if search_name.include?(UPPER_SPACE)
      search_name.gsub!(LOWER_SPACE, NO_SPACE) if search_name.include?(LOWER_SPACE)
      # タグタイプ取得
      tag = Tag.search_existing_tag(tag_name)
      tag_type_name = tag.present? ? tag.first.tag_type_name : OTHER_STR
      # タグタイプ判別
      tag_type_id = ScrapingService.descriminate_tag_type tag_type_name
      # タグハッシュ
      tag_hash = {
        tag_type_name: tag_type_name,
        tag_type_id: tag_type_id,
        tag_name: tag_name,
        tag_name_search: search_name,
      }
      # 既存スキルタグの判別と新規作成
      tag_hash[:tag_id] = ScrapingService.descriminate_tag_id tag_hash
      tags_list.push tag_hash
    end
  end
end
