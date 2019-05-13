# frozen_string_literal: true

module Queries
  module Users
    class AccountQuery < Queries::BaseQuery
      description "The user's Account details"

      type Types::Users::UsersAccountType, null: false

      def resolve
        context[:current_user]&.account
      end
    end
  end
end
