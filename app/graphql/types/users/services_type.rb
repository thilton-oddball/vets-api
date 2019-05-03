# frozen_string_literal: true

module Types
  module Users
    class ServicesType < Types::BaseObject
      field :services, [String], null: false
      field :errors, Types::Errors::StandardType, null: true

      def services
        object.dig(:services)
      end

      def errors
        error_details object.dig(:errors)
      end
    end
  end
end
