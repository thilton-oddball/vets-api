# frozen_string_literal: true

module Queries
  module Users
    class InProgressFormsQuery < Queries::BaseQuery
      description 'The list of in progress forms available to the user'

      type [Types::Users::UsersInProgressFormType], null: false

      def resolve
        user = context[:current_user]

        user.in_progress_forms.map do |form|
          {
            form: form.form_id,
            metadata: form.metadata,
            last_updated: form.updated_at.to_i
          }
        end
      end
    end
  end
end
