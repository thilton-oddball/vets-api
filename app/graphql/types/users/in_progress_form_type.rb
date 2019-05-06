# frozen_string_literal: true

module Types
  module Users
    class InProgressFormType < Types::BaseObject
      field :form, String, null: true
      field :metadata, Types::Users::InProgressFormMetadataType, null: true
      field :last_updated, Integer, null: true
    end
  end
end
