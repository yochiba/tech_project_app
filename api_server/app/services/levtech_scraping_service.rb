# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'

# class_type: Service
# class_name: LevtechScrapingService
# description: scraping class for Midworks
class LevtechScrapingService
  # https://freelance.levtech.jp/project/pref-13/
  # ホストURL
  HOST_URL = Settings.levtech.url.host
  # 新着案件URL
  NEW_PROJECTS_URL = Settings.levtech.url.new_projects
  # 東京都の案件
  AREA_TOKYO = 'pref-13'
  # FIXME 取得する最大ページ数
  MAX_PAGE_COUNT = 1
  # 1ページの表示件数
  PROJECTS_PER_PAGE = 20

  class << self
    # scraping service for levtech
    def scraping_root
      Rails.logger.info "[SCRAPING START]:: LevtechScrapingService"
      # 総案件数を取得するためのリクエスト
      url = "#{NEW_PROJECTS_URL}/#{AREA_TOKYO}"
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
          url = "#{NEW_PROJECTS_URL}/#{AREA_TOKYO}/p#{page}"
          url = "#{NEW_PROJECTS_URL}/#{AREA_TOKYO}" if page == 1
          project_list_html = Nokogiri::HTML.parse(open(url, allow_redirections: :all))
        rescue => exception
          Rails.logger.info exception
        end
        project_json_array = compose_project_json_array project_json_array, project_list_html
        sleep 2
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
        sleep 0.5
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
      puts "[PROJECT DETAIL]:: #{project_html}"
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
      # 案件の詳細情報
      detail_html = project_html.css('.pjtSummary')
      compose_price detail_html, project_hash
      # descriminate_detail_html detail_html, project_hash
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
      project_title.gsub!(/[\r\n]/, '')
      project_title.gsub!('New', '') if project_title.include?('New')
      project_hash[:create_json][:title] = project_title
      project_title
    end

    # 案件単価構成メソッド
    def compose_price(detail_html, project_hash)
      # FIXME ここから
      price_class = '.pjtSummary__row.pjtSummary__row--btn .pjtSummary__row__desc'
      price = detail_html.css(price_class).text
      project_hash[:create_json][:max_price] = price
    end

    # 業務内容の取得
    def compose_descripton(detail_html, project_hash)
      description = detail_html.css('.smaller-text.px-sm-4 p').text
      project_hash[:create_json][:description] = description if description.present?
    end
  end
end
