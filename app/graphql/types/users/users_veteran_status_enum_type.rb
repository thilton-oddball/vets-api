# frozen_string_literal: true

module Types
  module Users
    class UsersVeteranStatusEnumType < BaseEnum
      include Common::Client::ServiceStatus

      description 'The enum of potential veteran statuses'
      value(
        'OK',
        'No issues when checking veteran status in EMIS',
        value: RESPONSE_STATUS[:ok]
      )
      value(
        'NOT_FOUND',
        'Could not find information on the veteran status in EMIS',
        value: RESPONSE_STATUS[:not_found]
      )
      value(
        'SERVER_ERROR',
        'Experienced a server error when checking the veteran status through EMIS',
        value: RESPONSE_STATUS[:server_error]
      )
      value(
        'NOT_AUTHORIZED',
        'Not authorized to check status per EMIS',
        value: RESPONSE_STATUS[:not_authorized]
      )
    end
  end
end
