# frozen_string_literal: true

desc 'retry failed evss jobs'
task evss_retry_jobs: :environment do
  RELEASE_TIME = Time.zone.parse('2017-09-20T21:59:58.486Z')
  ERROR_CLASS = 'Aws::S3::Errors::NoSuchKey'

  Sidekiq::DeadSet.new.each do |job|
    if job.klass == 'EVSS::DocumentUpload'
      created_at = DateTime.strptime(job['created_at'].to_s, '%s')

      if created_at >= RELEASE_TIME && job['error_class'] == ERROR_CLASS
        EVSS::DocumentUpload.perform_async(*job.args)
        job.delete
      end
    end
  end
end

namespace :evss do
  desc 'export GIBS not found users, usage: rake evss:export_gibs_not_found[/export/path.csv]'
  task :export_gibs_not_found, [:csv_path] => [:environment] do |_, args|
    raise 'No CSV path provided' unless args[:csv_path]
    CSV.open(args[:csv_path], 'wb') do |csv|
      csv << %w[edipi first_name last_name ssn dob created_at]
      GibsNotFoundUser.find_each do |user|
        csv << [
          user.edipi,
          user.first_name,
          user.last_name,
          user.ssn,
          user.dob.strftime('%Y-%m-%d'),
          user.created_at.iso8601
        ]
      end
    end
  end

  desc '686 load test'
  task load_test_686: :environment do
    require './rakelib/support/vic_load_test'

    EVSS_TIME_KEYS = %w[createdDate expirationDate modifiedDate dateOfBirth dateUploaded courseBeginDate graduationDate termBeginDate]

    def convert_evss_time(time)
      time_string = time.to_s
      Time.at(BigDecimal.new(time_string.insert(time_string.size - 3, '.'))).iso8601
    end

    def change_evss_times(object)
      if object.is_a?(Hash)
        object.each do |k, v|
          if k.downcase.include?('date') && v.is_a?(Numeric)
            object[k] = convert_evss_time(v)
          else
            change_evss_times(v)
          end
        end
      elsif object.is_a?(Array)
        object.each do |item|
          change_evss_times(item)
        end
      end
    end
    # {"va_eauth_csid":"DSLogon","va_eauth_authenticationmethod":"DSLogon","va_eauth_pnidtype":"SSN","va_eauth_assurancelevel":"3","va_eauth_firstName":"WESLEY","va_eauth_lastName":"FORD","va_eauth_issueinstant":"2017-12-07T00:55:09Z","va_eauth_dodedipnid":"1007697216","va_eauth_birlsfilenumber":"796043735","va_eauth_pid":"600061742","va_eauth_pnid":"796043735","va_eauth_birthdate":"1986-05-06T00:00:00+00:00","va_eauth_authorization":"{\"authorizationResponse\":{\"status\":\"VETERAN\",\"idType\":\"SSN\",\"id\":\"796043735\",\"edi\":\"1007697216\",\"firstName\":\"WESLEY\",\"lastName\":\"FORD\",\"birthDate\":\"1986-05-06T00:00:00+00:00\"}}"}

    LoadTest.measure_elapsed do
      1.times do
        service = EVSS::Dependents::Service.new(nil)
        form = service.retrieve.body
        form = service.clean_form(form).body
        service.validate(form)
        form_id = service.save(form).body['form_id']
        form['submitProcess']['application']['draftFormId'] = form_id
        binding.pry; fail
        change_evss_times(form)
        service.submit(form)
      end
    end
  end

  desc 'export EDIPIs users with invalid addresss, usage: rake evss:export_invalid_address_edipis[/export/path.csv]'
  task :export_invalid_address_edipis, [:csv_path] => [:environment] do |_, args|
    raise 'No CSV path provided' unless args[:csv_path]
    CSV.open(args[:csv_path], 'wb') do |csv|
      csv << %w[edipi created_at]
      InvalidLetterAddressEdipi.find_each do |i|
        csv << [
          i.edipi,
          i.created_at.iso8601
        ]
      end
    end
  end

  desc 'export post 911 not found users for the last week, usage: rake evss:export_post_911_not_found[/export/path.csv]'
  task :export_post_911_not_found, [:file_path] => [:environment] do |_, args|
    raise 'No JSON file path provided' unless args[:file_path]
    File.open(args[:file_path], 'w+') do |f|
      PersonalInformationLog.where(error_class: 'EVSS::GiBillStatus::NotFound').last_week.find_each do |error|
        f.puts(error.data.to_json)
      end
    end
  end

  desc 'imports DoD facilities into base_facilities table'
  task import_dod_facilities: :environment do
    path = Rails.root.join('rakelib', 'support', 'files', 'dod_facilities.csv')
    CSV.foreach(path, headers: true) do |row|
      address = {
        physical: {
          zip: nil,
          city: row['city'],
          state: row['state'],
          country: row['country']
        }
      }.to_json
      id = SecureRandom.uuid
      Facilities::DODFacility.where(name: row['name'], address: address).first_or_create(
        id: id, name: row['name'], address: address, lat: 0.0, long: 0.0
      )
    end
  end
end
