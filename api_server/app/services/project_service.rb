# frozen_string_literal: true

# class_type: Service
# class_name: ProjectService
# description: common class for projects
class ProjectService
  class << self
    # get project_list
    def project_list(page, sort, search_query)
      pjt_list = []
      # offset
      offset = page.to_i * Settings.pjt_list_count
      # 一覧検索
      # if search_query.blank?
      #   pjts Project.project_list_latest offset
      # end
      pjts = Project.project_list_latest offset

      if pjts.present?
        pjts.map do |pjt|
          pjt_hash = pjt.as_json
          pjt_list.push pjt_hash
        end
      end
      pjt_list
    end

    private

    # organize search query
    def organize_search_query(search_query)
    end

    # compose project tag_list
    def compose_tag_list(pjt)
      tag_list = []
      mid_tags = pjt.mid_tags
      if mid_tags.present?
        mid_tags.map do |mid_tag|
          tag = Tag.find(mid_tag.tag_id)
          tag_hash = {
            tag_id: tag.id,
            tag_name: tag.tag_name,
            tag_type_name: tag.tag_type_name,
            tag_type_id: tag.tag_type_id,
          }
          tag_list.push tag_hash
        end
      end
      tag_list
    end

    # compose  project location
    def compose_location(pjt)
      location = pjt.location
      location_hash = {
        location_id: location.id,
        location_name: location.location_name,
      }
      location_hash
    end

    # compose project industry_list
    def compose_industry(pjt)
      industry = pjt.industry
      industry_hash = {
        industry_id: industry.id,
        industry_name: industry.industry_name,
      }
      industry_hash
    end

    # compose project position_list
    def comopse_position_list(pjt)
      position_list = []
      mid_positions = pjt.mid_positions
      if mid_positions.present?
        mid_positions.map do |mid_position|
          position = Position.find(mid_position.position_id)
          position_hash = {
            position_id: position.id,
            position_name: position.position_name,
          }
          position_list.push position_hash
        end
      end
      position_list
    end
  end
end
