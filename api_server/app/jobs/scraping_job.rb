# frozen_string_literal: true

class ScrapingJob < ApplicationJob
  queue_as :default

  def perform(options = {})
    Rails.logger.info "[SCRAPING JOB START]"
    case options[:job_type]
    when 'midworks'
      MidworksScrapingService.scraping_root
    when 'levtech'
      LevtechScrapingService.scraping_root
    when 'potepan'
      PotepanScrapingService.scraping_root
    end
    Rails.logger.info "[SCRAPING JOB END]"
  end
end
