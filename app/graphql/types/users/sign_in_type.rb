# frozen_string_literal: true

module Types
  module Users
    class SignInType < Types::BaseObject
      field :account_type, String, null: true
      field :service_name, String, null: true
    end
  end
end
