# frozen_string_literal: true

module Queries
  module Users
    class VeteranStatusQuery < Queries::BaseQuery
      include Common::Client::ServiceStatus

      description "The user's veteran status details"

      type Types::Users::VeteranStatusType, null: false

      def resolve
        user = context[:current_user]
        veteran_status = {
          status: RESPONSE_STATUS[:ok],
          is_veteran: user.veteran?,
          served_in_military: user.served_in_military?
        }

        veteran_status_response(veteran_status: veteran_status)
      rescue StandardError => e
        veteran_status_response(errors: error(e))
      end

      private

      def veteran_status_response(veteran_status: {}, errors: nil)
        {
          veteran_status: veteran_status,
          errors: errors
        }
      end

      def error(e)
        ::Users::ExceptionHandler.new(e, 'EMIS').serialize_error
      end
    end
  end
end
