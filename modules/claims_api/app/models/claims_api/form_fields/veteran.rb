# frozen_string_literal: true

require 'claims_api/form_field'

module ClaimsApi
  module FormFields
    class Veteran
      # "veteran": {
      #     "currentlyVAEmployee": false,
      #     "currentMailingAddress": {
      #       "addressLine1": "1234 Couch Street",
      #       "addressLine2": "Apt. 22",
      #       "city": "Portland",
      #       "country": "USA",
      #       "zipFirstFive": "12345",
      #       "zipLastFour": "6789",
      #       "type": "DOMESTIC",
      #       "state": "OR"
      #     },
      #     "changeOfAddress": {
      #       "beginningDate": "2018-06-04",
      #       "addressChangeType": "PERMANENT",
      #       "addressLine1": "1234 Couch Street",
      #       "addressLine2": "Apt. 22",
      #       "city": "Portland",
      #       "country": "USA",
      #       "zipFirstFive": "12345",
      #       "zipLastFour": "6789",
      #       "type": "DOMESTIC",
      #       "state": "OR"
      #     },
      #     "homelessness": {
      #       "pointOfContact": {
      #         "pointOfContactName": "Jane Doe",
      #         "primaryPhone": {
      #           "areaCode": "123",
      #           "phoneNumber": "1231234"
      #         }
      #       },
      #       "currentlyHomeless": {
      #         "homelessSituationType": "FLEEING_CURRENT_RESIDENCE",
      #         "otherLivingSituation": "other living situation"
      #       }
      #     }
      #   },
      ROOT = ClaimsApi::FormField.new(
        key: :veteran,
        required: false
      )
      SUB_FIELDS = [
        { key: :currentlyVAEmployee },
        ClaimsApi::FormFields::Veteran::CurrentMailingAddress,
        ClaimsApi::FormField.new(key: :changeOfAddress, required: false)
        { key: :homelessness }
      ].freeze
    end
  end
end
