# frozen_string_literal: true
require 'csv'

namespace :emis do
  desc 'Dump eMIS attributes for all users in mock MVI database'
  task :dump, [:ymlfile, :outfile] => [:environment] do |_, args|
    raise 'No input YAML provided' unless args[:ymlfile]
    outfile = args[:outfile] || 'emis_dump.csv.generated'
    vss = EMIS::VeteranStatusService.new
    mis = EMIS::MilitaryInformationService.new

    mock = YAML.load_file(args[:ymlfile])
    CSV.open(outfile, 'w') do |file|
      file << %w(first last ssn edipi addressee old_is_veteran title38 branches discharges)
      mock['find_candidate'].each do |ssn, user|
        is_veteran = false
        begin
          resp = vss.get_veteran_status(edipi: user[:edipi])
          title38 = resp.items.first&.title38_status_code || 'NA'
          is_veteran = any_veteran_indicator?(resp.items.first)
          ep_resp = mis.get_military_service_episodes(edipi: user[:edipi])
          eps = ep_resp&.items || []
          branches = eps.map { |e| e.branch_of_service_code }
          branchstring = branches.compact.join('/')
          discharges = eps.map { |e| e.discharge_character_of_service_code }
          dischargestring = discharges.compact.join('/')
        rescue StandardError => e
          puts "Error #{e} for #{user[:given_names][0]} #{user[:family_name]} #{ssn}"
          is_veteran = false
        end
        has_addr = addressee?(user[:address])
        file << [user[:given_names][0], user[:family_name], ssn,
                 user[:edipi], has_addr, is_veteran, title38, 
                 branchstring, dischargestring]
      end
    end
  end
end

def any_veteran_indicator?(item)
  item&.post911_deployment_indicator == 'Y' ||
    item&.post911_combat_indicator == 'Y' ||
    item&.pre911_deployment_indicator == 'Y'
end

def addressee?(addr)
  return false if addr.blank?
  return false if addr.country.blank?
  return false if addr.state.blank?
  true
end
