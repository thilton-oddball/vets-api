# frozen_string_literal: true
require 'common/client/base'
require 'evss/auth_headers'

module EVSS
  class Service < Common::Client::Base
    SYSTEM_NAME = 'vets.gov'
    include SentryLogging

    def headers_for_user(user)
      EVSS::AuthHeaders.new(user).to_h
    end

    def perform_with_user_headers(method, path, body, headers = {}, &block)
      log_message_to_sentry('user used for call', :info, email: @current_user.email.delete('@'))

      perform(
        method,
        path,
        body,
        headers_for_user(@current_user).merge(headers),
        &block
      )
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
