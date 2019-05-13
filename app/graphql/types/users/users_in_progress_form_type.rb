# frozen_string_literal: true

module Types
  module Users
    class UsersInProgressFormType < Types::BaseObject
      field :form, String, null: true
      field :metadata, Types::Users::UsersInProgressFormMetadataType, null: true
      field :last_updated, Integer, null: true
    end
  end
end
