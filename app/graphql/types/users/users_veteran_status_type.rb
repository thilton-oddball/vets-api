# frozen_string_literal: true

module Types
  module Users
    class UsersVeteranStatusType < Types::BaseObject
      field :status, Types::Users::UsersVeteranStatusEnumType, null: true
      field :is_veteran, Boolean, null: true
      field :served_in_military, Boolean, null: true

      def status
        object.dig(:status)
      end

      # rubocop:disable Naming/PredicateName
      def is_veteran
        object.dig(:is_veteran)
      end
      # rubocop:enable Naming/PredicateName

      def served_in_military
        object.dig(:served_in_military)
      end
    end
  end
end
