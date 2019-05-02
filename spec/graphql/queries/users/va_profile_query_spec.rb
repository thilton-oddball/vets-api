# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::Users::VaProfileQuery do
  let(:user) { build(:user, :loa3) }
  let(:query) do
    <<-GRAPHQL
      query {
        userVaProfile {
          status
          birthDate
          familyName
          gender
          givenNames
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
    expect(results['status']).to eq 'OK'
  end

  it 'returns the expected VA profile data', :aggregate_failures do
    fields.each do |field|
      expect(results[field]).to eq user.va_profile.send(field.underscore)
    end
  end

  it 'returns no errors' do
    expect(response.dig('data', 'errors')).to be_nil
  end

  context 'with a non-OK status' do
    let(:user) { build :user }
    let(:response) { VetsAPISchema.execute(query, context: { current_user: user }) }
    let(:results) { response.dig('data', 'userVaProfile') }

    it 'returns error details', :aggregate_failures do
      response = VetsAPISchema.execute(query, context: { current_user: user })
      errors   = results.dig('errors')

      expect(errors.dig('status')).to eq '401'
      expect(errors.dig('externalService')).to eq 'MVI'
      expect(errors.dig('startTime')).to be_present
      expect(errors.dig('endTime')).to be_nil
      expect(errors.dig('description')).to include 'Not authorized'
    end

    it 'returns the non-OK status' do
      expect(results['status']).to eq 'NOT_AUTHORIZED'
    end

    it 'sets all of the va_profile fields to nil', :aggregate_failures do
      fields.each do |field|
        expect(results[field]).to be_nil
      end
    end
  end
end
