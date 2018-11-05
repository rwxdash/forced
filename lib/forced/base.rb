module Forced
  class Base
    class << self
      def get_records(request)
        @client_platform = get_client_platform(request)
        @client_version = get_client_version(request)

        @client_version_records = (@client_platform && @client_version ? Client.find_by!(identifier: @client_platform).versions : nil)
        @versions_after_client = @client_version_records&.where('version > ?', @client_version)
        @latest_app_version = @client_version_records&.last
        @any_forced_in_the_future = @versions_after_client&.pluck(:force_update)&.any?
      end

      private

      def get_client_platform(request)
        return request.headers['X-Platform'].to_s.downcase
      end

      def get_client_version(request)
        return request.headers['X-Client-Version']
      end

      def check_update_status(client_version, latest_app_version, any_forced_in_the_future)
        nil_report = []
        nil_report << MESSAGES[:app_version_returned_nil] if latest_app_version.nil?
        nil_report << MESSAGES[:client_version_returned_nil] if client_version.nil?

        return nil_report.join(', ') if !nil_report.empty?

        client_v = Gem::Version.new(client_version)
        latest_v = Gem::Version.new(latest_app_version.version)

        case
        when client_v == latest_v
          return MESSAGES[:no_update]
        when client_v < latest_v
          any_forced_in_the_future ? MESSAGES[:force_update] : MESSAGES[:just_update]
        when client_v > latest_v
          return MESSAGES[:client_is_ahead_of_backend]
        else
          return MESSAGES[:something_went_wrong]
        end
      end
    end
  end
end
