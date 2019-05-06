# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::Users::AccountQuery do
  let(:user) { build(:user, :accountable) }
  let(:account_uuid) { user.account_uuid }
  let(:query) do
    <<-GRAPHQL
      query {
        userAccount {
          accountUuid
        }
      }
    GRAPHQL
  end

  let(:response) { VetsAPISchema.execute(query, context: { current_user: user }) }
  let(:results) { response.dig('data', 'userAccount') }

  it 'returns the users#account_uuid' do
    expect(results.dig('accountUuid')).to eq account_uuid
  end
end
