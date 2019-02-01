# frozen_string_literal: true

module Common
  module Exceptions
    # Parameter Missing - required parameter was not provided
    class NotASafeHostError < BaseError
      attr_reader :host

      def initialize(host)
        @host = host
      end

      private

      def interpolated
        i18n_interpolated(detail: { host: @host })
      end
    end
  end
end
