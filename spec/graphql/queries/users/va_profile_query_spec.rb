# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::Users::VaProfileQuery do
  let(:user) { build(:user, :loa3) }
  let(:query) do
    <<-GRAPHQL
      query {
        userVaProfile {
          vaProfile {
            status
            birthDate
            familyName
            gender
            givenNames
          }
          errors {
            externalService
            startTime
            endTime
            description
            status
          }
        }
      }
    GRAPHQL
  end

  let(:response) { VetsAPISchema.execute(query, context: { current_user: user }) }
  let(:results) { response.dig('data', 'userVaProfile') }
  let(:fields) do
    %w[
      birthDate
      familyName
      gender
      givenNames
    ]
  end

  it 'returns a status of OK' do
    expect(results.dig('vaProfile', 'status')).to eq 'OK'
  end

  it 'returns the expected VA profile data', :aggregate_failures do
    fields.each do |field|
      expect(results.dig('vaProfile', field)).to eq user.va_profile.send(field.underscore)
    end
  end

  it 'returns no errors' do
    expect(results.dig('errors')).to be_nil
  end

  context 'with a non-OK status' do
    let(:user) { build :user }
    let(:response) { VetsAPISchema.execute(query, context: { current_user: user }) }
    let(:results) { response.dig('data', 'userVaProfile') }

    it 'returns error details', :aggregate_failures do
      error = results.dig('errors')

      expect(error.dig('status')).to eq '401'
      expect(error.dig('externalService')).to eq 'MVI'
      expect(error.dig('startTime')).to be_present
      expect(error.dig('endTime')).to be_nil
      expect(error.dig('description')).to include 'Not authorized'
    end

    it 'returns the non-OK status' do
      expect(results.dig('vaProfile', 'status')).to eq 'NOT_AUTHORIZED'
    end

    it 'sets all of the va_profile fields to nil', :aggregate_failures do
      fields.each do |field|
        expect(results[field]).to be_nil
      end
    end
  end
end
