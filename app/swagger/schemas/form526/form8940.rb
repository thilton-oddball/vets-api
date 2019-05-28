# frozen_string_literal: true

module Swagger
  module Schemas
    module Form526
      class Form8940
        include Swagger::Blocks
        date_pattern = Regexp.new(Swagger::Schemas::Form526::Form526SubmitV2::DATE_PATTERN.inspect).to_js
        swagger_schema :Form8940 do
          property :unemployability, type: :object do
            property :mostIncome, type: :number
            property :yearEarned, type: :string
            property :job, type: :string
            property :disabilityPreventingEmployment, type: :string
            property :underDoctorHopitalCarePast12M, type: :boolean
            property :doctorProvidedCare, type: :array do
              items type: :object do
                key :'$ref', :ProvidedCare
              end
            end
            property :hospitalProvidedCare, type: :array do
              items type: :object do
                key :'$ref', :ProvidedCare
              end
            end
            property :disabilityAffectedEmploymentFullTimeDate,
                     type: :string,
                     pattern: date_pattern
            property :lastWorkedFullTimeDate,
                     type: :string,
                     pattern: date_pattern
            property :becameTooDisabledToWorkDate,
                     type: :string,
                     pattern: date_pattern
            property :mostEarningsInAYear, type: :string
            property :yearOfMostEarnings, type: :string
            property :occupationDuringMostEarnings, type: :string
            property :previousEmployers, type: :array do
              items type: :object do
                key :'$ref', :PreviousEmployer
              end
            end
            property :disabilityPreventMilitaryDuties, type: :boolean
            property :past12MonthsEarnedIncome,
                     type: :number,
                     minimum: 0,
                     maximum: 9_999_999.99
            property :currentMonthlyEarnedIncome,
                     type: :number,
                     minimum: 0,
                     maximum: 9_999_999.99
            property :leftLastJobDueToDisability, type: :boolean
            property :leftLastJobDueToDisabilityRemarks, type: :string
            property :receiveExpectDisabilityRetirement, type: :boolean
            property :receiveExpectWorkersCompensation, type: :boolean
            property :attemptedToObtainEmploymentSinceUnemployability, type: :boolean
            property :appliedEmployers, type: :array do
              items type: :object do
                key :'$ref', :AppliedEmployer
              end
            end
            property :education, type: :string, enum:
              [
                'Some elementary school',
                'Some high school',
                'High school diploma or GED',
                'Some college',
                'Associate\'s degree',
                'Bachelor’s degree',
                'Master’s degree',
                'Doctoral degre',
                'Other'
              ]
            property :receivedOtherEducationTrainingPreUnemployability, type: :boolean
            property :otherEducationTrainingPreUnemployability, type: :array do
              items type: :object do
                property :name, type: :string
                property :dates, type: :object do
                  key :'$ref', :DateRange
                end
              end
            end
            property :remarks, type: :string
          end
        end

        swagger_schema :ProvidedCare do
          property :name, type: :string
          property :address, type: :object do
            key :'$ref', :AddressNoRequiredFields
          end
          property :dates, type: :string
        end

        swagger_schema :PreviousEmployer do
          property :name, type: :string
          property :employerAddress, type: :object do
            key :'$ref', :AddressNoRequiredFields
          end
          property :phone,
                   type: :string,
                   pattern: Regexp.new("/^\\d{10}$/").to_js
          property :typeOfWork, type: :string
          property :hoursPerWeek, type: :number, minLength: 0, maxLength: 999
          property :dates, type: :object do
            key :'$ref', :DateRange
          end
          property :timeLostFromIllness, type: :string
          property :mostEarningsInAMonth, type: :number, minimum: 0
          property :inBusiness, type: :boolean
        end

        swagger_schema :AppliedEmployer do
          property :name, type: :string
          property :address, type: :object do
            key :'$ref', :AddressNoRequiredFields
          end
          property :workType, type: :string
          property :date,
                   type: :string,
                   pattern: date_pattern
        end
      end
    end
  end
end
