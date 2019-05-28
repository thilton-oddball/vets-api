# frozen_string_literal: true

module Swagger
  module Schemas
    module Gibct
      class Institutions
        include Swagger::Blocks

        STATES = %i[
          ak al ar as az ca co ct dc de fl fm ga gu hi ia
          id il in ks ky la ma md me mh mi mn mo mp ms mt
          nc nd ne nh nj nm nv ny oh ok or pa pr pw ri sc
          sd tn tx ut va vi vt wa wi wv wy
        ].freeze

        swagger_schema :GibctInstitutionsAutocomplete do
          key :required, %i[data meta links]

          property :data, type: :array, minItems: 0, uniqueItems: true do
            items do
              property :id, type: :integer
              property :value, type: :string
              property :label, type: :string
            end
          end

          property :meta, '$ref': :GibctInstitutionsAutocompleteMeta
          property :links, '$ref': :GibctInstitutionsSelfLinks
        end

        swagger_schema :GibctInstitutionsSearch do
          key :required, %i[data meta links]

          property :data, type: :array, maxItems: 10, uniqueItems: true do
            items do
              key :type, :object
              key :required, %i[id type attributes links]

              property :id, type: :string
              property :type, type: :string, enum: ['institutions']
              property :links, '$ref': :GibctInstitutionsSelfLinks
              property :attributes do
                key :$ref, :GibctInstitutionBase

                property :type, type: :string,
                                enum: ['OJT', 'PRIVATE', 'FOREIGN', 'CORRESPONDENCE', 'FLIGHT', 'FOR PROFIT', 'PUBLIC']
              end
            end
          end

          property :meta, '$ref': :GibctInstitutionsSearchMeta
          property :links, '$ref': :GibctInstitutionsSearchLinks
        end

        swagger_schema :GibctInstitution do
          key :type, :object
          key :required, %i[data meta]

          property :data, type: :object do
            key :required, %i[id type attributes links]

            property :id, type: :string
            property :type, type: :string, enum: ['institutions']
            property :links, '$ref': :GibctInstitutionsSelfLinks

            property :attributes do
              key :$ref, :GibctInstitutionBase

              property :type, type: :string,
                              enum: ['ojt', 'private', 'foreign', 'correspondence', 'flight', 'for profit', 'public']
              property :flight, type: :boolean
              property :correspondence, type: :boolean
              property :cross, type: :string
              property :ope, type: :string
              property :ope6, type: :string
              property :undergrad_enrollment, type: :integer
              property :student_veteran, type: :boolean
              property :student_veteran_link, type: :string
              property :dodmou, type: :boolean
              property :sec_702, type: :boolean
              property :vet_success_name, type: :string
              property :vet_success_email, type: :string
              property :credit_for_mil_training, type: :boolean
              property :vet_poc, type: :boolean
              property :student_vet_grp_ipeds, type: :boolean
              property :soc_member, type: :boolean
              property :retention_rate_veteran_ba, type: :number
              property :retention_all_students_ba, type: :number
              property :retention_rate_veteran_otb, type: :number
              property :retention_all_students_otb, type: :number
              property :persistance_rate_veteran_ba, type: :number
              property :persistance_rate_veteran_otb, type: :number
              property :graduation_rate_veteran, type: :number
              property :graduation_rate_all_students, type: :number
              property :transfer_out_rate_veteran, type: :number
              property :transfer_out_rate_all_students, type: :number
              property :salary_all_students, type: :number
              property :repayment_rate_all_students, type: :number
              property :avg_stu_loan_debt, type: :number
              property :calendar, type: :string
              property :online_all, type: :string
              property :p911_tuition_fees, type: :number
              property :p911_recipients, type: :integer
              property :p911_yellow_ribbon, type: :number
              property :p911_yr_recipients, type: :integer
              property :accredited, type: :boolean
              property :accreditation_type, type: :string
              property :accreditation_status, type: :string
              property :complaints, type: :object do
                property :facility_code, type: :integer
                property :financial_by_fac_code, type: :integer
                property :quality_by_fac_code, type: :integer
                property :refund_by_fac_code, type: :integer
                property :marketing_by_fac_code, type: :integer
                property :accreditation_by_fac_code, type: :integer
                property :degree_requirements_by_fac_code, type: :integer
                property :student_loans_by_fac_code, type: :integer
                property :grades_by_fac_code, type: :integer
                property :credit_transfer_by_fac_code, type: :integer
                property :credit_job_by_fac_code, type: :integer
                property :job_by_fac_code, type: :integer
                property :transcript_by_fac_code, type: :integer
                property :other_by_fac_code, type: :integer
                property :main_campus_roll_up, type: :integer
                property :financial_by_ope_id_do_not_sum, type: :integer
                property :quality_by_ope_id_do_not_sum, type: :integer
                property :refund_by_ope_id_do_not_sum, type: :integer
                property :marketing_by_ope_id_do_not_sum, type: :integer
                property :accreditation_by_ope_id_do_not_sum, type: :integer
                property :degree_requirements_by_ope_id_do_not_sum, type: :integer
                property :student_loans_by_ope_id_do_not_sum, type: :integer
                property :grades_by_ope_id_do_not_sum, type: :integer
                property :credit_transfer_by_ope_id_do_not_sum, type: :integer
                property :jobs_by_ope_id_do_not_sum, type: :integer
                property :transcript_by_ope_id_do_not_sum, type: :integer
                property :other_by_ope_id_do_not_sum, type: :integer
              end
            end
          end

          property :meta, '$ref': :GibctInstitutionsShowMeta
        end

        swagger_schema :GibctInstitutionsAutocompleteMeta do
          key :type, :object
          key :required, %i[version term]

          property :version, type: :integer
          property :term, type: :string
        end

        swagger_schema :GibctInstitutionsSearchMeta do
          key :type, :object
          key :required, %i[version count facets]

          property :version, type: :object do
            key :required, %i[number created_at preview]

            property :number, type: :integer
            property :created_at, type: :string
            property :preview, type: :boolean
          end

          property :count, type: :integer
          property :facets, type: :object do
            key :required, %i[
              category type state country student_vet_group
              yellow_ribbon_scholarship principles_of_excellence
              eight_keys_to_veteran_success
            ]

            property :category, type: :object do
              key :required, %i[school employer]

              property :school, type: :integer
              property :employer, type: :integer
            end

            property :type, type: :object do
              key :required, [:correspondence, :flight, :foreign, :'for profit', :ojt, :private, :public]

              property :correspondence, type: :integer
              property :flight, type: :integer
              property :foreign, type: :integer
              property :'for profit', type: :integer
              property :ojt, type: :integer
              property :private, type: :integer
              property :public, type: :integer
            end

            property :state, type: :object do
              key :required, STATES

              STATES.each { |state| property state, type: :integer }
            end

            property :country, type: :array do
              items do
                key :type, :object
                key :required, %i[name count]

                property :name, type: :string
                property :count, type: :integer
              end
            end

            property :student_vet_group, '$ref': :null_boolean_counts
            property :yellow_ribbon_scholarship, '$ref': :null_boolean_counts
            property :principles_of_excellence, '$ref': :null_boolean_counts
            property :eight_keys_to_veteran_success, '$ref': :null_boolean_counts
          end
        end

        swagger_schema :GibctInstitutionsShowMeta do
          key :type, :object
          key :required, [:version]

          property :version, type: :integer
        end

        swagger_schema :GibctInstitutionsSearchLinks do
          key :type, :object
          key :required, %i[self first prev next last]

          property :self, type: :string
          property :first, type: :string
          property :prev, type: :string
          property :next, type: :string
          property :last, type: :string
        end

        swagger_schema :GibctInstitutionBase do
          key :required, %i[
            name facility_code type city state zip country highest_degree locale_type
            student_count caution_flag caution_flag_reason created_at updated_at bah
            tuition_in_state tuition_out_of_state books student_veteran yr poe eight_keys
          ]
          property :name, type: :string
          property :facility_code, type: :string
          property :type, type: :string # TODO: Check what this should be
          property :city, type: :string
          property :state, type: :string
          property :zip, type: :string
          property :country, type: :string
          property :highest_degree, type: :integer
          property :locale_type, type: :string
          property :student_count, type: :integer
          property :caution_flag, type: :boolean
          property :caution_flag_reason, type: :string
          property :created_at, type: :string
          property :updated_at, type: :string
          property :bah, type: :number
          property :tuition_in_state, type: :number
          property :tuition_out_of_state, type: :number
          property :books, type: :number
          property :student_veteran, type: :boolean
          property :yr, type: :boolean
          property :poe, type: :boolean
          property :eight_keys, type: :boolean
        end

        swagger_schema :GibctInstitutionsSelfLinks do
          key :type, :object
          key :required, [:self]

          property :self, type: :string
        end

        swagger_schema :null_boolean_counts do
          key :type, :object
          key :required, %i[true false]

          property :true, type: :integer
          property :false, type: :integer
        end
      end
    end
  end
end
