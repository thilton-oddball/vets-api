# frozen_string_literal: true

module Types
  module Users
    class UsersVeteranStatusPayloadType < Types::BaseObject
      field :veteran_status, Types::Users::UsersVeteranStatusType, null: true
      field :errors, Types::Errors::ErrorsUserExternalServiceType, null: true
    end
  end
end
