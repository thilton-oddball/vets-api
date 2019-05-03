# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::Users::ServicesQuery do
  let(:user) { build(:user, :accountable) }
  let(:account_uuid) { user.account_uuid }
  let(:query) do
    <<-GRAPHQL
      query {
        userServices {
          services
          errors {
            type
            message
          }
        }
      }
    GRAPHQL
  end

  let(:response) { VetsAPISchema.execute(query, context: { current_user: user }) }
  let(:results) { response.dig('data', 'userServices') }

  it 'returns an array of authorized services', :aggregate_failures do
    expect(results.dig('services').class).to eq Array
    expect(results.dig('services')).to include 'facilities', 'hca', 'edu-benefits'
  end

  it 'returns no errors' do
    expect(response.dig('data', 'errors')).to be_nil
  end

  context 'with an error' do
    before do
      allow_any_instance_of(Users::Services).to receive(:authorizations).and_raise(StandardError, 'some error')
    end

    it 'returns error details', :aggregate_failures do
      response = VetsAPISchema.execute(query, context: { current_user: user })
      errors   = response.dig('data', 'userServices', 'errors')

      expect(errors.dig('type')).to eq 'StandardError'
      expect(errors.dig('message')).to eq 'some error'
    end
  end
end
