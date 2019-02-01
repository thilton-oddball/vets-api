# frozen_string_literal: true

module Common
  module Exceptions
    # Service Outage - Breakers is reporting an outage on a backend system
    class ServiceOutage < BaseError
      def initialize(outage = nil, options = {})
        @outage = outage
        @detail = options[:detail] || i18n_field(:detail, service: @outage.service.name, since: @outage.start_time)
      end

      private

      def internal_service_error
        i18n_data.merge(detail: @detail)
      end
    end
  end
end
