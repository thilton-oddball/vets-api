# frozen_string_literal: true

module Types
  module Errors
    class UserExternalServiceType < Types::BaseObject
      field :external_service, String, null: false
      field :start_time, String, null: false
      field :end_time, String, null: true
      field :description, String, null: true
      field :status, String, null: true
    end
  end
end
