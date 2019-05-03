# frozen_string_literal: true

module Queries
  module Users
    class Vet360ContactInformationQuery < Queries::BaseQuery
      description "The user's Vet360 contact information details"

      type Types::Users::Vet360ContactInformationType, null: false

      def resolve
        user   = context[:current_user]
        person = user.vet360_contact_info

        raise_exception_if_no_person!(person)
        vet360_response person
      rescue StandardError => e
        vet360_response person, error(e)
      end

      private

      def vet360_response(person, errors = nil)
        {
          person: person,
          errors: errors
        }
      end

      def error(e)
        ::Users::ExceptionHandler.new(e, 'Vet360').serialize_error
      end

      # TODO: in /v0/user, when person.blank? is true, it returns an empty hash.
      # The frontend will need to refactor to accommodate for this error
      # being raised, instead.
      #
      def raise_exception_if_no_person!(person)
        if person.blank?
          raise Common::Exceptions::BackendServiceException.new(
            'VET360_CORE103',
            { source: self.class },
            400,
            'User needs to initialize a vet360_id'
          )
        end
      end
    end
  end
end
