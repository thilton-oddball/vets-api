# frozen_string_literal: true

module Queries
  module Users
    class AccountQuery < Queries::BaseQuery
      description "The user's Account details"

      type Types::Users::UsersAccountType, null: false

      def resolve
        user = context[:current_user]

        Account.cache_or_create_by!(user)
      end
    end
  end
end
