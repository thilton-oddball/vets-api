# frozen_string_literal: true

module Common
  module Exceptions
    class GatewayTimeout < BaseError
      private

      def interpolated
        i18n_data
      end
    end
  end
end
