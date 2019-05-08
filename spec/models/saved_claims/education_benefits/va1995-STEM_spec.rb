# frozen_string_literal: true

require 'rails_helper'
require 'lib/saved_claims_spec_helper'

RSpec.describe SavedClaim::EducationBenefits::VA1995_STEM do
  let(:instance) { FactoryBot.build(:va1995_STEM) }
  it_should_behave_like 'saved_claim'

  validate_inclusion(:form_id, '22-1995-STEM')
end
