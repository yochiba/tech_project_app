# frozen_string_literal: true

class ScrapingJob < ApplicationJob
  queue_as :default

  def perform(options = {})
    Rails.logger.info "[SCRAPING JOB START]"
    result_flg = false
    case options[:job_type]
    when 'midworks'
      pjt_json_list = MidworksScrapingService.scraping_root
      result_flg = ScrapingService.compose_project_json pjt_json_list
    when 'levtech'
      pjt_json_list = LevtechScrapingService.scraping_root
      result_flg = ScrapingService.compose_project_json pjt_json_list
    when 'potepan'
      pjt_json_list = PotepanScrapingService.scraping_root
      result_flg = ScrapingService.compose_project_json pjt_json_list
    end

    log_info = result_flg ? '[SCRAPING JOB SUCCEEDED]' : '[SCRAPING JOB FAILED]'

    Rails.logger.info log_info
  end
end
