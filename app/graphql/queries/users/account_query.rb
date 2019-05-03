# frozen_string_literal: true

module Queries
  module Users
    class AccountQuery < Queries::BaseQuery
      description "The user's Account details"

      type Types::Users::AccountType, null: false

      def resolve
        user    = context[:current_user]
        account = user.account

        account_response(account)
      rescue StandardError => e
        account_response(account, e)
      end

      private

      def account_response(account, errors = nil)
        {
          account: account,
          errors: errors
        }
      end
    end
  end
end
