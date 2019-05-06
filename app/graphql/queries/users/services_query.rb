# frozen_string_literal: true

module Queries
  module Users
    class ServicesQuery < Queries::BaseQuery
      description 'The list of services available to the user'

      type [String], null: false

      def resolve
        user = context[:current_user]

        ::Users::Services.new(user).authorizations
      end
    end
  end
end
