# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'csv'

# Service for scraping
class MidworksScrapingService
  # FIXME 取得する最大ページ数
  MAX_PAGE_COUNT = 1
  # 1ページの表示件数
  PROJECT_COUNT_ONE_PAGE = 25

  class << self
    # scraping service for midworks
    def compose_projects_json
      # 総案件数を取得するためのリクエスト
      url = "#{Settings.midworks.url.new_projects}"
      new_projects_page_html = Nokogiri::HTML.parse(open(url))
      # 案件情報格納配列
      projects_array = []
      # 総案件数
      total_projects = new_projects_page_html.css('.text-primary.lead.font-weight-bold').text.to_i
      ## 指定ページ数のみ取得
      page_count = total_projects / PROJECT_COUNT_ONE_PAGE
      page_count_array = page_count >= MAX_PAGE_COUNT ? [*1..MAX_PAGE_COUNT] : [*1..page_count]
      page_count_array.map do |page|
        url = "#{Settings.midworks.url.new_projects}?page=#{page}"
        begin
          project_list_html = Nokogiri::HTML.parse(open(url))
          # 案件ID配列
          project_id_array = project_list_html.css('.col-12 a')
          project_id_array.map do |project_id|
            project_url = "#{Settings.midworks.url.host}#{project_id[:href]}"
            project_hash = compose_project(project_url)
            projects_array.push(project_hash)
            sleep 0.8
          end
          sleep 5
        rescue => exception
          puts exception
        end
      end
      projects_array
    end

    private

    # 各案件の情報を構成
    def compose_project(url)
      begin
        project_html = Nokogiri::HTML.parse(open(url))
        # 案件データ格納ハッシュ
        project_hash = {company_name: Settings.midworks.company_name, company_id: Settings.midworks.company_id, url: url}
        # 案件名称
        project_title = project_html.css('.project-name.p-4 h1').text      
        project_hash[:title] = project_title if project_title.present?
        # 案件の詳細情報
        detail_html_array = project_html.css('.col-lg-9.mt-4.mb-2 .mb-5')
        descriminate_detail_html detail_html_array, project_hash
        project_hash
      rescue => exception
        puts exception
      end
    end

    # 案件詳細判別メソッド
    def descriminate_detail_html(detail_html_array, project_hash)
      detail_html_array.map do |detail_html|
        # 案件詳細情報の各項目のタイトルを取得
        detail_title = detail_html.css('h2').text
        next if detail_title.blank?
        case detail_title
        when Settings.midworks.title.description then
          compose_descripton detail_html, project_hash
        when Settings.midworks.title.skill then
          compose_skills detail_html, project_hash
        when Settings.midworks.title.detail then
          compose_detail detail_html, project_hash
        when Settings.midworks.title.skill_tags then
          compose_skill_tags detail_html, project_hash
        else
          next
        end
      end
    end

    # 業務内容の取得
    def compose_descripton(detail_html, project_hash)
      description = detail_html.css('.smaller-text.px-sm-4 p').text
      project_hash[:description] = description if description.present?
    end

    # スキルについて取得
    def compose_skills(detail_html, project_hash)
      skill_html_array = detail_html.css('row')
      skill_html_array.map do |skill_html|
        skill_subtitle = skill_html.css('.smaller-text.px-sm-4 .col-12.col-md-2 .font-weight-bold.mb-2').text
        case skill_subtitle
        when Settings.midworks.title.required_skills then
          required_skills = skill_html.css('.smaller-text.px-sm-4 .col-12.col-md-10 p').text
          project_hash[:required_skills] = required_skills if required_skills.present?
        when Settings.midworks.title.other_skills then
          other_skills = skill_html.css('.smaller-text.px-sm-4 .col-12.col-md-10 p').text
          project_hash[:other_skills] = other_skills if other_skills.present?
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
        when Settings.midworks.title.price then
          price_with_operation = detail.css('td .d-md-flex').text
          compose_price price_with_operation, project_hash
          compose_operation price_with_operation, project_hash
        when Settings.midworks.title.weekly_attendance then
          weekly_attendance = detail.css('td').text.tr('０-９', '0-9').gsub(/[^\d]/, '').to_i
          project_hash[:weekly_attendance] = weekly_attendance if weekly_attendance.present?
        when Settings.midworks.title.location then
          location = detail.css('td').text
          project_hash[:location] = location if location.present?
        when Settings.midworks.title.position then
          position = detail.css('td').text
          project_hash[:position] = position if position.present?
        when Settings.midworks.title.contract then
          contract = detail.css('td').text
          project_hash[:contract] = contract if contract.present?
        else
          next
        end
      end
    end

    # 単価構成メソッド
    def compose_price(price_with_operation, project_hash)
      # 最大単価と最小単価
      price_array = price_with_operation.gsub(/（(.*?)）/, '').split('~')
      project_hash[:min_price] = price_array[0].gsub(/[^\d]/, '').to_i
      project_hash[:max_price] = price_array[1].gsub(/[^\d]/, '').to_i
      price_unit_name = price_array[1].gsub(/（(.*?)）/, '').delete('0-9')
      project_hash[:price_unit] = descriminate_price_unit_id price_unit_name
    end

    # 単価単位ID判別メソッド
    def descriminate_price_unit_id(price_unit_name)
      price_unit_id = 0
      case price_unit_name
      when Settings.midworks.price_unit.man_yen_per_month then
        price_unit_id = Settings.price_unit_id.man_yen_per_month
      else
        price_unit_id = 1
      end
      {
        price_unit_id: price_unit_id,
        price_unit_name: price_unit_name,
      }
    end

    # 稼働構成メソッド
    def compose_operation(price_with_operation, project_hash)
      # 最小稼働単位と最大稼働単位の配列
      operation_unit_array = price_with_operation[/（(.*?)）/, 1].split(' ~ ')
      project_hash[:min_operation_unit] = operation_unit_array[0].gsub(/[^\d]/, '').to_i
      project_hash[:max_operation_unit] = operation_unit_array[1].gsub(/[^\d]/, '').to_i
      operation_unit_name = operation_unit_array[0].delete('0-9')
      # 稼働単位
      project_hash[:operation_unit] = descripinate_operation_unit_id operation_unit_name
    end

    # 稼働単位ID判別メソッド
    def descripinate_operation_unit_id(operation_unit_name)
      operation_unit_id = 0
      case operation_unit_name
      when Settings.midworks.operation_unit.hour then
        operation_unit_id = Settings.operation_unit_id.hour
      else
        operation_unit_id = 1
      end
      {
        operation_unit_id: operation_unit_id,
        operation_unit_name: operation_unit_name,
      }
    end

    # スキルタグ構成メソッド
    def compose_skill_tags(detail_html, project_hash)
      skill_tags_html_array = detail_html.css('.smaller-text.px-sm-4 .row')
      skill_tags_array = []
      skill_tags_html_array.map { |skill_tag_html| discriminate_skills(skill_tag_html, skill_tags_array) }
      project_hash[:skill_tags] = skill_tags_array
    end

    # スキル判別メソッド
    def discriminate_skills(skill_tag_html, skill_tags_array)
      skill_type_title = skill_tag_html.css('.col-5.col-sm-3 .title-plain').text
      skill_tag_name_html_array = skill_tag_html.css('.col-7.col-sm-9 .row a .tag.mr-2.mb-1')
      skill_tag_name_html_array.map do |skill_tag_name_html|
        skill_tag_name = skill_tag_name_html.text
        next if skill_tag_name.blank?
        # スキルタイプ判別
        skill_type = descriminate_skill_type skill_type_title
        ## FIXME
        # skill_id = descripminate_skill_id
        skill_hash = {
          skill_type_title: skill_type_title,
          skill_type: skill_type,
          skill_tag_name: skill_tag_name,
        }
        skill_tags_array.push skill_hash
      end
      skill_tags_array
    end

    # スキルタイプ判別メソッド
    def descriminate_skill_type(skill_type_title)
      skill_type = 0
      case skill_type_title
      when Settings.midworks.skill_type.language then
        skill_type = Settings.skill_type.language
      when Settings.midworks.skill_type.framework then
        skill_type = Settings.skill_type.framework
      when Settings.midworks.skill_type.db then
        skill_type = Settings.skill_type.db
      when Settings.midworks.skill_type.tool then
        skill_type = Settings.skill_type.tool
      when Settings.midworks.skill_type.os then
        skill_type = Settings.skill_type.os
      when Settings.midworks.skill_type.package then
        skill_type = Settings.skill_type.package
      else
        skill_type = Settings.skill_type.others
      end
      skill_type
    end

    # スキルID判別メソッド(仮) 仕様検討中
    def descripminate_skill_id(skill_name)
      # DB(skill_tags)に検索をかけに行って、該当しなければ新しく追加
      # 該当する場合は既存の物を仕様
      # 検索条件：全て半角+大文字にして検索&保存を行えばOK?
    end
  end
end
