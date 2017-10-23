# frozen_string_literal: true
# rubocop:disable Metrics/CyclomaticComplexity
module DataMigrations
  module CheckEducationClaims
    module_function

    def run
      EducationBenefitsClaim.includes(:saved_claim).where('encrypted_form IS NOT NULL').find_each do |education_benefits_claim|
        
      end
    end
  end
end
