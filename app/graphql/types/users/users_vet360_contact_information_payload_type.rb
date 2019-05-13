# frozen_string_literal: true

module Types
  module Users
    class UsersVet360ContactInformationPayloadType < Types::BaseObject
      field :person, Types::Users::UsersVet360ContactInformationType, null: true
      field :errors, Types::Errors::ErrorsUserExternalServiceType, null: true
    end
  end
end
