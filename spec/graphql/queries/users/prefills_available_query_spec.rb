# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::Users::PrefillsAvailableQuery do
  let(:user) { build(:user, :loa3) }
  let(:query) do
    <<-GRAPHQL
      query {
        userPrefillsAvailable
      }
    GRAPHQL
  end

  let(:response) { VetsAPISchema.execute(query, context: { current_user: user }) }
  let(:results) { response.dig('data', 'userPrefillsAvailable') }

  it 'populates with an array of available prefills' do
    expect(results).to be_present
  end

  context 'when user cannot access prefill data' do
    before do
      allow_any_instance_of(UserIdentity).to receive(:blank?).and_return(true)
    end

    it 'returns an empty array' do
      expect(results).to eq []
    end
  end
end
