# frozen_string_literal: true

module Common
  module Exceptions
    # Routing Error - if route is invalid
    class UnknownFormat < BaseError
      attr_reader :format

      def initialize(format = nil)
        @format = format
      end

      private

      def interpolated
        i18n_interpolated(detail: { format: @format })
      end
    end
  end
end
