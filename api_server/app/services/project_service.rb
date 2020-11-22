# frozen_string_literal: true

# class_type: Service
# class_name: ProjectService
# description: common class for projects
class ProjectService
  class << self
    # get project_list
    def project_list(page)
      project_list = []
      # OFFSET
      offset = page.to_i * Settings.project_list_count
      # GET PROJECT LIST
      projects = Project.project_list offset
      if projects.present?
        projects.map do |project|
          project_hash = project.as_json
          tag_list = compose_tag_list project
          project_hash[:tag_list] = tag_list if tag_list.present?
          project_hash[:location] = compose_location project if project.location_id.present?
          project_hash[:industry] = compose_industry project if project.industry_id.present?
          position_list = comopse_position_list project
          project_hash[:position_list] = position_list if position_list.present?
          project_list.push project_hash
        end
      end
      project_list
    end

    private

    # compose project tag_list
    def compose_tag_list(project)
      tag_list = []
      mid_tags = project.mid_tags
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
    def compose_location(project)
      location = project.location
      location_hash = {
        location_id: location.id,
        location_name: location.location_name,
      }
      location_hash
    end

    # compose project industry_list
    def compose_industry(project)
      industry = project.industry
      industry_hash = {
        industry_id: industry.id,
        industry_name: industry.industry_name,
      }
      industry_hash
    end

    # compose project position_list
    def comopse_position_list(project)
      position_list = []
      mid_positions = project.mid_positions
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
