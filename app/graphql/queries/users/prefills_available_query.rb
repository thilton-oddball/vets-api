# frozen_string_literal: true

module Queries
  module Users
    class PrefillsAvailableQuery < Queries::BaseQuery
      description "The user's available prefills"

      type [String], null: true

      def resolve
        return [] if context[:current_user]&.identity.blank?

        FormProfile.prefill_enabled_forms
      end
    end
  end
end
