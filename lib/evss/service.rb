# frozen_string_literal: true

require 'common/client/base'
require 'evss/auth_headers'

module EVSS
  class Service < Common::Client::Base
    include Common::Client::Monitoring
    STATSD_KEY_PREFIX = 'api.evss'

    def initialize(user)
      @user = user
      @headers = headers_for_user(@user)
    end

    def perform(method, path, body = nil, headers = {}, options = {})
      merged_headers = @headers.merge(headers)
      super(method, path, body, merged_headers, options)
    end

    def headers
      { 'Content-Type' => 'application/json' }
    end

    def self.service_is_up?
      last_evss_claims_outage = Breakers::Outage.find_latest(service: EVSS::ClaimsService.breakers_service)
      evss_claims_up = last_evss_claims_outage.blank? || last_evss_claims_outage.end_time.present?

      last_evss_common_outage = Breakers::Outage.find_latest(service: EVSS::CommonService.breakers_service)
      evss_common_up = last_evss_common_outage.blank? || last_evss_common_outage.end_time.present?
      evss_claims_up && evss_common_up
    end

    private

    def with_monitoring_and_error_handling
      with_monitoring(2) do
        yield
      end
    rescue StandardError => e
      handle_error(e)
    end

    def headers_for_user(user)
      EVSS::AuthHeaders.new(user).to_h
    end

    def save_error_details(error)
      Raven.tags_context(
        external_service: self.class.to_s.underscore
      )

      Raven.extra_context(
        url: config.base_path,
        message: error.message,
        body: error.body
      )
    end

    def handle_error(error)
      Raven.extra_context(
        message: error.message,
        url: config.base_path
      )

      case error
      when Faraday::ParsingError
        raise_backend_exception('EVSS502', self.class)
      when Common::Client::Errors::ClientError
        Raven.extra_context(body: error.body)
        raise Common::Exceptions::Forbidden if error.status == 403
        raise_backend_exception('EVSS400', self.class, error) if error.status == 400
        raise_backend_exception('EVSS502', self.class, error)
      else
        raise error
      end
    end

    def raise_backend_exception(key, source, error = nil)
      raise Common::Exceptions::BackendServiceException.new(
        key,
        { source: "EVSS::#{source}" },
        error&.status,
        error&.body
      )
    end
  end
end
