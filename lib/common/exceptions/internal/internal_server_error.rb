# frozen_string_literal: true

module Common
  module Exceptions
    # Internal Server Error - all exceptions not readily accounted fall into this tier
    class InternalServerError < BaseError
      attr_reader :exception

      def initialize(exception)
        raise ArgumentError, 'an exception must be provided' unless exception.is_a?(Exception)
        @exception = exception
      end

      private

      def interpolated
        meta = { backtrace: exception.backtrace } unless ::Rails.env.production?
        i18n_data.merge(detail: @exception.message, meta: meta)
      end
    end
  end
end
