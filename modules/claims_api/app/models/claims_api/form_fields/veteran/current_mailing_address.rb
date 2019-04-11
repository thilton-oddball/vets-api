# frozen_string_literal: true

require 'claims_api/form_field'

module ClaimsApi
  module FormFields
    module Veteran
      class CurrentMailingAddress
        ROOT = ClaimsApi::FormField.new(
          key: :currentMailingAddress,
          required: true
        )

        SUB_FIELDS = [
          ClaimsApi::FormField.new(key: :addressLine1, required: true),
          ClaimsApi::FormField.new(key: :city, required: true),
          ClaimsApi::FormField.new(key: :state, required: true),
          ClaimsApi::FormField.new(key: :zipFirstFive, required: true),
          ClaimsApi::FormField.new(key: :country, required: true)
        ].freeze
      end
    end
  end
end
