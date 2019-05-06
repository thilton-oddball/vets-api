# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::Users::InProgressFormsQuery do
  let(:user) { build(:user, :loa3) }
  let(:query) do
    <<-GRAPHQL
      query {
        userInProgressForms {
          form
          lastUpdated
          metadata {
            expiresAt
            lastUpdated
            returnUrl
            version
          }
        }
      }
    GRAPHQL
  end

  let(:response) { VetsAPISchema.execute(query, context: { current_user: user }) }
  let(:results) { response.dig('data', 'userInProgressForms') }

  context 'when user has an in progress form' do
    let!(:in_progress_form) { create(:in_progress_form, user_uuid: user.uuid) }
    let(:first_form) { results[0] }

    it 'returns the in progress form data', :aggregate_failures do
      expect(first_form.dig('form')).to be_present
      expect(first_form.dig('lastUpdated')).to be_present
    end

    it 'returns the expected metadata' do
      metadata = first_form.dig('metadata').transform_keys { |key| key.underscore }

      expect(metadata).to eq in_progress_form.metadata
    end
  end

  context 'when the user does not have any in progress forms' do
    it 'returns an empty array' do
      expect(results).to eq []
    end
  end
end
