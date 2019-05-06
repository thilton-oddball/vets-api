# frozen_string_literal: true

module Types
  module Users
    class InProgressFormMetadataType < Types::BaseObject
      field :version, Integer, null: true
      field :return_url, String, null: true
      field :expires_at, Integer, null: true
      field :last_updated, Integer, null: true
    end
  end
end

