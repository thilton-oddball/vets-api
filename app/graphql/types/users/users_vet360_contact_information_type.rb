# frozen_string_literal: true

module Types
  module Users
    class UsersVet360ContactInformationType < Types::BaseObject
      field :email, Types::Users::UsersEmailType, null: true
      field :residential_address, Types::Users::UsersAddressType, null: true
      field :mailing_address, Types::Users::UsersAddressType, null: true
      field :mobile_phone, Types::Users::UsersPhoneType, null: true
      field :home_phone, Types::Users::UsersPhoneType, null: true
      field :work_phone, Types::Users::UsersPhoneType, null: true
      field :temporary_phone, Types::Users::UsersPhoneType, null: true
      field :fax_number, Types::Users::UsersPhoneType, null: true
      field :errors, Types::Errors::ErrorsUserExternalServiceType, null: true

      def email
        person&.email
      end

      def residential_address
        person&.residential_address
      end

      def mailing_address
        person&.mailing_address
      end

      def mobile_phone
        person&.mobile_phone
      end

      def home_phone
        person&.home_phone
      end

      def work_phone
        person&.work_phone
      end

      def temporary_phone
        person&.temporary_phone
      end

      def fax_number
        person&.fax_number
      end

      def errors
        object.dig(:errors).presence
      end

      private

      def person
        object.dig(:person)
      end
    end
  end
end
