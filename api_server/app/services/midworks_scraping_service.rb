# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

# class_type: Service
# class_name: MidworkScrapingService
# description: scraping class for Midworks
class MidworksScrapingService
  # FIXME 取得する最大ページ数
  MAX_PAGE_COUNT = 1
  # 1ページの表示件数
  PROJECT_COUNT_ONE_PAGE = 25

  class << self
    # scraping service for midworks
    def scraping_root
      Rails.logger.info "[SCRAPING START]:: MidworksScrapingService"
      # 総案件数を取得するためのリクエスト
      # FIXME クエリストリングが反応反応しない
      url = "#{Settings.midworks.url.new_projects}?#{{ area_keys: [
        'shinjuku_ku',
        'toshima_ku',
        'suginami_ku',
        'meguro_ku',
        'katsushika_ku',
        'tokyo_others',
      ] }.to_query}"
      Rails.logger.info "[PROJECT LIST URL]:: #{url}"
      new_projects_page_html = Nokogiri::HTML.parse(open(url))
      # 総案件数からページ数取得
      total_projects = new_projects_page_html.css('.text-primary.lead.font-weight-bold').text.to_i
      page_count = total_projects / PROJECT_COUNT_ONE_PAGE
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
          url = "#{Settings.midworks.url.new_projects}?page=#{page}"
          project_list_html = Nokogiri::HTML.parse(open(url))
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
      project_id_array = project_list_html.css('.col-12 a')
      project_id_array.map do |project_id|
        project_url = "#{Settings.midworks.url.host}#{project_id[:href]}"
        project_json_array.push compose_project(project_url)
        sleep 1
      end
      project_json_array
    end

    # 各案件の情報を構成
    def compose_project(url)
      begin
        Rails.logger.info "[SCRAPING TARGET URL]:: #{url}"
        project_html = Nokogiri::HTML.parse(open(url))
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
      }
      # 案件名称
      project_title = project_html.css('.project-name.p-4 h1').text
      project_hash[:create_json][:title] = project_title if project_title.present?
      # 案件の詳細情報
      detail_html_array = project_html.css('.col-lg-9.mt-4.mb-2 .mb-5')
      descriminate_detail_html detail_html_array, project_hash
      project_hash
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
        case skill_subtitle
        when Settings.midworks.title.required_skills
          required_skills = skill_html.css('.col-12.col-md-10 p').text
          project_hash[:create_json][:required_skills] = required_skills if required_skills.present?
        when Settings.midworks.title.other_skills
          other_skills = skill_html.css('.col-12.col-md-10 p').text
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
          price_with_operation = detail.css('td .d-md-flex').text
          compose_price price_with_operation, project_hash
          compose_operation price_with_operation, project_hash
        when Settings.midworks.title.weekly_attendance
          attendance = detail.css('td').text.tr('０-９', '0-9').gsub(/[^\d]/, '').to_i
          project_hash[:create_json][:weekly_attendance] = attendance if attendance.present?
        when Settings.midworks.title.location
          location = detail.css('td').text
          project_hash[:create_json].merge!({
            location_id: location.present? ? ProjectService.compose_location_id(location) : 0,
            location: location.present? ? location : '',
          })
        when Settings.midworks.title.position
          industry = detail.css('td').text
          project_hash[:create_json].merge!({
            industry_id: industry.present? ? ProjectService.compose_industry_id(industry) : 0,
            industry: industry.present? ? industry : '',
          })
        when Settings.midworks.title.industry
          position = detail.css('td').text
          project_hash[:create_json].merge!({
            position_id: position.present? ? ProjectService.compose_position_id(position) : 0,
            position: position.present? ? position : '',
          })
        when Settings.midworks.title.contract
          contract = detail.css('td').text
          project_hash[:create_json].merge!({
            contract_id: contract.present? ? ProjectService.compose_contract_id(contract) : 0,
            contract: contract.present? ? contract : '',
          })
        else
          next
        end
      end
    end

    # 単価構成メソッド
    def compose_price(price_with_operation, project_hash)
      # 最大単価と最小単価
      price_array = price_with_operation.gsub(/（(.*?)）/, '').split('~')
      project_hash[:create_json].merge!({
        min_price: price_array[0].gsub(/[^\d]/, '').to_i,
        max_price: price_array[1].gsub(/[^\d]/, '').to_i,
      })
      price_unit_name = price_array[1].gsub(/（(.*?)）/, '').delete('0-9')
      project_hash[:create_json].merge! descriminate_price_unit_id price_unit_name
    end

    # 単価単位ID判別メソッド
    def descriminate_price_unit_id(price_unit_name)
      price_unit_id = 0
      case price_unit_name
      when Settings.midworks.price_unit.man_yen_per_month
        price_unit_id = Settings.price_unit_id.man_yen_per_month
      else
        price_unit_id = 1
      end
      {
        price_unit_id: price_unit_id,
        price_unit: price_unit_name,
      }
    end

    # 稼働構成メソッド
    def compose_operation(price_with_operation, project_hash)
      # ~◯◯万円/月と~◯◯万円/月（◯◯◯時間 ~ ◯◯◯時間）の判別
      operation = price_with_operation[/（(.*?)）/, 1]
      if operation.present?
        # 最小稼働単位と最大稼働単位の配列
        operation_unit_array = operation.split(' ~ ')
        project_hash[:create_json].merge!({
          min_operation_unit: operation_unit_array[0].gsub(/[^\d]/, '').to_i,
          max_operation_unit: operation_unit_array[1].gsub(/[^\d]/, '').to_i,
        })
        operation_unit_name = operation_unit_array[0].delete('0-9')
        # 稼働単位
        project_hash[:create_json].merge! descripinate_operation_unit_id operation_unit_name
      end
    end

    # 稼働単位ID判別メソッド
    def descripinate_operation_unit_id(operation_unit_name)
      operation_unit_id = 0
      case operation_unit_name
      when Settings.midworks.operation_unit.hour
        operation_unit_id = Settings.operation_unit_id.hour
      else
        operation_unit_id = 1
      end
      {
        operation_unit_id: operation_unit_id,
        operation_unit: operation_unit_name,
      }
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
      skill_type_title = skill_tag_html.css('.col-5.col-sm-3 .title-plain').text
      skill_tag_name_html_array = skill_tag_html.css('.col-7.col-sm-9 .row a .tag.mr-2.mb-1')
      skill_tag_name_html_array.map do |skill_tag_name_html|
        # スキル名称
        skill_tag_name = skill_tag_name_html.text
        # スキル名称検索用(全角,大文字,空白なし)
        skill_tag_name_search = skill_tag_name.upcase.tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z')
        skill_tag_name_search.gsub!('　', '').gsub!(' ', '')
        next if skill_tag_name.blank?
        # スキルタイプ判別
        skill_type_id = descriminate_skill_type skill_type_title
        # skillハッシュ
        skill_tag_hash = {
          skill_type_title: skill_type_title,
          skill_type_id: skill_type_id,
          skill_tag_name: skill_tag_name,
          skill_tag_name_search: skill_tag_name_search,
        }
        # 既存スキルタグの判別と新規作成
        skill_tag_hash[:skill_tag_id] = ProjectService.descriminate_skill_id skill_tag_hash
        skill_tags_array.push skill_tag_hash
      end
      skill_tags_array
    end

    # スキルタイプ判別メソッド
    def descriminate_skill_type(skill_type_title)
      skill_type = 0
      case skill_type_title
      when Settings.midworks.skill_type.language
        skill_type = Settings.skill_type.language
      when Settings.midworks.skill_type.framework
        skill_type = Settings.skill_type.framework
      when Settings.midworks.skill_type.db
        skill_type = Settings.skill_type.db
      when Settings.midworks.skill_type.tool
        skill_type = Settings.skill_type.tool
      when Settings.midworks.skill_type.os
        skill_type = Settings.skill_type.os
      when Settings.midworks.skill_type.package
        skill_type = Settings.skill_type.package
      else
        skill_type = Settings.skill_type.others
      end
      skill_type
    end
  end
end
