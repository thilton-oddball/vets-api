# frozen_string_literal: true

module Queries
  module Users
    class VaProfileQuery < Queries::BaseQuery
      include Common::Client::ServiceStatus

      description "The user's VA Profile details"

      type Types::Users::UsersVaProfilePayloadType, null: false

      def resolve
        user   = context[:current_user]
        status = user.va_profile_status

        if status == RESPONSE_STATUS[:ok]
          va_profile_response(status, va_profile: user.va_profile)
        else
          va_profile_response(status, errors: error(user))
        end
      end

      private

      def va_profile_response(status, va_profile: nil, errors: nil)
        {
          profile: {
            status: status,
            va_profile: va_profile
          },
          errors: errors
        }
      end

      def error(user)
        ::Users::ExceptionHandler.new(user.va_profile_error, 'MVI').serialize_error
      end
    end
  end
end
