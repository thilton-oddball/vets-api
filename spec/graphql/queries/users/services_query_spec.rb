# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::Users::ServicesQuery do
  let(:user) { build(:user, :accountable) }
  let(:account_uuid) { user.account_uuid }
  let(:query) do
    <<-GRAPHQL
      query {
        userServices
      }
    GRAPHQL
  end

  let(:response) { VetsAPISchema.execute(query, context: { current_user: user }) }
  let(:results) { response.dig('data', 'userServices') }

  it 'returns an array of authorized services', :aggregate_failures do
    expect(results.class).to eq Array
    expect(results).to include 'facilities', 'hca', 'edu-benefits'
  end
end
