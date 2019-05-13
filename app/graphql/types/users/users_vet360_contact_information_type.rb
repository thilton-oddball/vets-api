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
    end
  end
end
