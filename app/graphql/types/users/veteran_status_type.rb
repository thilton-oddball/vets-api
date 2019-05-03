# frozen_string_literal: true

module Types
  module Users
    class VeteranStatusType < Types::BaseObject
      field :status, Types::Users::VeteranStatusEnumType, null: true
      field :is_veteran, Boolean, null: true
      field :served_in_military, Boolean, null: true
      field :errors, Types::Errors::UserExternalServiceType, null: true

      def status
        veteran_status.dig(:status)
      end

      def is_veteran
        veteran_status.dig(:is_veteran)
      end

      def served_in_military
        veteran_status.dig(:served_in_military)
      end

      def errors
        object.dig(:errors).presence
      end

      private

      def veteran_status
        object.dig(:veteran_status)
      end
    end
  end
end
