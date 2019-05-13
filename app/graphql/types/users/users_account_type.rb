# frozen_string_literal: true

module Types
  module Users
    # Defines the fields on Account. Fields expose the data that may
    # be queried, and validated.
    #
    class UsersAccountType < Types::BaseObject
      field :account_uuid, String, null: true

      def account_uuid
        object&.uuid
      end
    end
  end
end
