# frozen_string_literal: true

module Queries
  module Users
    class ServicesQuery < Queries::BaseQuery
      description 'The list of services available to the user'

      type Types::Users::ServicesType, null: false

      def resolve
        user = context[:current_user]

        services_response(services: services(user))
      rescue StandardError => e
        services_response(errors: e)
      end

      private

      def services_response(services: [], errors: nil)
        {
          services: services,
          errors: errors
        }
      end

      def services(user)
        ::Users::Services.new(user).authorizations
      end
    end
  end
end
