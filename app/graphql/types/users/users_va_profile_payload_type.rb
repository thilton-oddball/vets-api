# frozen_string_literal: true

module Types
  module Users
    class UsersVaProfilePayloadType < Types::BaseObject
      field :va_profile, Types::Users::UsersVaProfileType, null: true
      field :errors, Types::Errors::ErrorsUserExternalServiceType, null: true

      def va_profile
        object.dig(:profile)
      end
    end
  end
end
