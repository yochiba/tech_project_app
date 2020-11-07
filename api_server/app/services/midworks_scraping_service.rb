# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'

# class_type: Service
# class_name: MidworksScrapingService
# description: scraping class for Midworks
class MidworksScrapingService
  # ホストURL
  HOST_URL = Settings.midworks.url.host
  # 新着案件URL
  NEW_PROJECTS_URL = Settings.midworks.url.new_projects
  # クエリストリング: area_keys
  AREA_KEYS = [
    'shinjuku_ku',
    'toshima_ku',
    'suginami_ku',
    'meguro_ku',
    'katsushika_ku',
    'tokyo_others',
  ].freeze
  # 取得する最大ページ数
  MAX_PAGE_COUNT = 3
  # 1ページの表示件数
  PROJECTS_PER_PAGE = 25
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

  class << self
    # scraping service for midworks
    def scraping_root
      Rails.logger.info "[SCRAPING START]:: MidworksScrapingService"
      # 総案件数を取得するためのリクエスト
      url = "#{NEW_PROJECTS_URL}?#{{ area_keys: AREA_KEYS }.to_query}"
      Rails.logger.info "[PROJECT LIST URL]:: #{url}"
      new_projects_page_html = Nokogiri::HTML.parse(open(url, allow_redirections: :all))
      # 総案件数からページ数取得
      total_projects = new_projects_page_html.css('.text-primary.lead.font-weight-bold').text.to_i
      page_count = total_projects / PROJECTS_PER_PAGE
      page_count_array = page_count >= MAX_PAGE_COUNT ? [*1..MAX_PAGE_COUNT] : [*1..page_count]
      # 案件情報json作成
      project_json_array = request_project_list page_count_array
      Rails.logger.info "[SCRAPING END]:: MidworksScrapingService"
      project_json_array
    end

    private

    # 案件情報一覧リクエストメソッド
    def request_project_list(page_count_array)
      project_json_array = []
      page_count_array.map do |page|
        begin
          url = "#{NEW_PROJECTS_URL}?#{{ area_keys: AREA_KEYS, page: page }.to_query}"
          project_list_html = Nokogiri::HTML.parse(open(url, allow_redirections: :all))
        rescue => exception
          Rails.logger.info exception
        end
        project_json_array = compose_project_json_array project_json_array, project_list_html
        sleep 10
      end
      project_json_array
    end

    # 案件情報json配列構成メソッド
    def compose_project_json_array(project_json_array, project_list_html)
      project_id_array = project_list_html.css('.col-12 a')
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
          company: Settings.midworks.company_name,
          company_id: Settings.midworks.company_id,
          url: url,
        },
        error_project: false,
      }
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
      detail_html_array = project_html.css('.col-lg-9.mt-4.mb-2 .mb-5')
      descriminate_detail_html detail_html_array, project_hash
      project_hash
    end

    # 案件名称構成メソッド
    def compose_project_title(project_html, project_hash)
      # 案件名称
      project_title = project_html.css('.project-name.p-4 h1').text
      # 案件名称が存在しない場合
      if project_title.blank?
        project_hash[:error_project] = true
        return project_hash
      end
      project_hash[:create_json][:title] = project_title
      project_title
    end

    # 案件詳細判別メソッド
    def descriminate_detail_html(detail_html_array, project_hash)
      detail_html_array.map do |detail_html|
        # 案件詳細情報の各項目のタイトルを取得
        detail_title = detail_html.css('h2').text
        next if detail_title.blank?
        case detail_title
        when Settings.midworks.title.description
          compose_descripton detail_html, project_hash
        when Settings.midworks.title.skill
          compose_skills detail_html, project_hash
        when Settings.midworks.title.detail
          compose_detail detail_html, project_hash
        when Settings.midworks.title.skill_tags
          compose_skill_tags detail_html, project_hash
        else
          next
        end
      end
    end

    # 業務内容の取得
    def compose_descripton(detail_html, project_hash)
      description = detail_html.css('.smaller-text.px-sm-4 p').text
      project_hash[:create_json][:description] = description if description.present?
    end

    # スキルについて取得
    def compose_skills(detail_html, project_hash)
      skill_html_array = detail_html.css('.row')
      skill_html_array.map do |skill_html|
        skill_subtitle = skill_html.css('.col-12.col-md-2 .font-weight-bold.mb-2').text
        skill_class = '.col-12.col-md-10 p'
        case skill_subtitle
        when Settings.midworks.title.required_skills
          required_skills = skill_html.css(skill_class).text
          project_hash[:create_json][:required_skills] = required_skills if required_skills.present?
        when Settings.midworks.title.other_skills
          other_skills = skill_html.css(skill_class).text
          project_hash[:create_json][:other_skills] = other_skills if other_skills.present?
        else
          next
        end
      end
    end

    # 案件詳細(単価、稼働時間、など)構成メソッド
    def compose_detail(detail_html, project_hash)
      detail_array = detail_html.css('table.table.table-bordered tr')
      detail_array.map do |detail|
        detail_subtitle = detail.css('th').text
        case detail_subtitle
        when Settings.midworks.title.price
          price_with_ope = detail.css('td .d-md-flex').text
          compose_price price_with_ope, project_hash
          compose_operation price_with_ope, project_hash
        when Settings.midworks.title.weekly_attendance
          attendance = detail.css('td').text.tr(UPPER_NUMS, LOWER_NUMS).gsub(/[^\d]/, NO_SPACE).to_i
          project_hash[:create_json][:weekly_attendance] = attendance if attendance.present?
        when Settings.midworks.title.location
          location = detail.css('td').text
          break if location.blank?
          project_hash[:location_name] = location
          project_hash[:create_json][:location_id] = ProjectService.compose_location_id(location)
        when Settings.midworks.title.industry
          industry = detail.css('td').text
          break if industry.blank?
          project_hash[:industry_name] = industry
          project_hash[:create_json][:industry_id] = ProjectService.compose_industry_id(industry)
        when Settings.midworks.title.position
          position_html_array = detail.css('td')
          break if position_html_array.blank?
          project_hash[:position_array] = ProjectService.compose_position position_html_array
        when Settings.midworks.title.contract
          contract = detail.css('td').text
          break if contract.blank?
          project_hash[:contract_name] = contract
          project_hash[:create_json][:contract_id] = ProjectService.compose_contract_id(contract)
        else
          next
        end
      end
    end

    # 単価構成メソッド
    def compose_price(price_with_ope, project_hash)
      # 最大単価と最小単価
      price_array = price_with_ope.gsub(/（(.*?)）/, NO_SPACE).split('~')
      price_unit_name = price_array[1].gsub(/（(.*?)）/, NO_SPACE).delete('0-9')
      project_hash[:create_json].merge! ProjectService.descriminate_price_unit_id price_unit_name
      # FIXME 全ての値に * 10000してしまうとイレギュラーが来た場合に変な値になる
      project_hash[:create_json].merge!({
        min_price: price_array[0].gsub(/[^\d]/, NO_SPACE).to_i * 10000,
        max_price: price_array[1].gsub(/[^\d]/, NO_SPACE).to_i * 10000,
      })
    end

    # 稼働構成メソッド
    def compose_operation(price_with_ope, project_hash)
      # ~◯◯万円/月と~◯◯万円/月（◯◯時間 ~ ◯◯時間）の判別
      operation = price_with_ope[/（(.*?)）/, 1]
      if operation.present?
        # 最小稼働単位と最大稼働単位の配列
        ope_unit_array = operation.split(' ~ ')
        project_hash[:create_json].merge!({
          min_operation_unit: ope_unit_array[0].gsub(/[^\d]/, NO_SPACE).to_i,
          max_operation_unit: ope_unit_array[1].gsub(/[^\d]/, NO_SPACE).to_i,
        })
        ope_unit_name = ope_unit_array[0].delete(LOWER_NUMS)
        # 稼働単位
        project_hash[:create_json].merge! ProjectService.descriminate_ope_unit_id ope_unit_name
      end
    end

    # スキルタグ構成メソッド
    def compose_skill_tags(detail_html, project_hash)
      skill_tags_html_array = detail_html.css('.smaller-text.px-sm-4 .row')
      skill_tags_array = []
      skill_tags_html_array.map do |skill_tag_html|
        discriminate_skills skill_tag_html, skill_tags_array
      end
      project_hash[:skill_tag_array] = skill_tags_array
    end

    # スキル判別メソッド
    def discriminate_skills(skill_tag_html, skill_tags_array)
      skill_type_name = skill_tag_html.css('.col-5.col-sm-3 .title-plain').text
      skill_tag_name_html_array = skill_tag_html.css('.col-7.col-sm-9 .row a .tag.mr-2.mb-1')
      skill_tag_name_html_array.map do |skill_tag_name_html|
        # スキル名称
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
