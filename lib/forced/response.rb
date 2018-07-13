module Forced
  class Response < Base
    class << self
      def call(request)
        get_records(request)

        return status = {
          update: check_update_status(@client_version, @latest_app_version, @any_forced_in_the_future),
          latest_version: @latest_app_version&.version,
          current_time: Time.zone.now
        }
      end
    end
  end
end
