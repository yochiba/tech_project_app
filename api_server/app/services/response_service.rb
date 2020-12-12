# frozen_string_literal: true

# class_type: Service
# class_name: ResponseService
# description: common class for response json
class ResponseService
  class << self
    # 200 OK
    STATUS_OK = Settings.res.ok.status
    RESULT_OK = Settings.res.ok.result
    # 204 NO CONTENT
    STATUS_NO_CONTENT = Settings.res.no_content.status
    RESULT_NO_CONTENT = Settings.res.no_content.result
    # 500 INTERNAL SERVER ERROR
    STATUS_ERROR = Settings.res.error.status
    RESULT_ERROR = Settings.res.error.result

    # scraping response json
    def scraping_response_json(pjt_json_list, result_flg)
      res_json = {
        project_count: pjt_json_list.size,
        project_list: pjt_json_list,
        status: result_flg ? STATUS_OK : STATUS_ERROR,
        result: result_flg ? RESULT_OK : RESULT_ERROR,
      }
      res_json
    end

    # project json
    def pjt_json(pjt_json)
      res_json = {
        status: pjt_json['id'].present? ? STATUS_OK : STATUS_NO_CONTENT,
        result: pjt_json['id'].present? ? RESULT_OK : RESULT_NO_CONTENT,
      }
      res_json.merge! pjt_json if pjt_json['id'].present?
      res_json
    end

    # projects list search result
    def pjts_list_search_result_json(pjt_json)
      res_json = {
        status: pjt_json[:pjts_count].zero? ? STATUS_NO_CONTENT : STATUS_OK,
        result: pjt_json[:pjts_count].zero? ? RESULT_NO_CONTENT : RESULT_OK,
      }
      res_json.merge! pjt_json
      res_json
    end
  end
end
