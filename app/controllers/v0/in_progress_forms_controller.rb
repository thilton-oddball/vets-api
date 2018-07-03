# frozen_string_literal: true

module V0
  class InProgressFormsController < ApplicationController
    include IgnoreNotFound

    before_action :check_access_denied
    before_action(:tag_rainbows)

    def index
      render json: InProgressForm.where(user_uuid: @current_user.uuid)
    end

    def show
      return render(json: {:form_data=>
        {"veteranFullName"=>{"first"=>"Abraham", "last"=>"Lincoln", "suffix"=>"Jr."},
         "gender"=>"M",
         "veteranDateOfBirth"=>"1809-02-12",
         "veteranSocialSecurityNumber"=>"111223333",
         "homePhone"=>"(303) 555-1234",
         "veteranAddress"=>{"street"=>"1493 Martin Luther King Rd", "city"=>"Fulton", "state"=>"MS", "country"=>"USA", "postalCode"=>"38843"},
         "email"=>"person101@example.com",
         "toursOfDuty"=>[{"serviceBranch"=>"Air Force", "dateRange"=>{"from"=>"2007-04-01", "to"=>"2016-06-01"}}],
         "currentlyActiveDuty"=>{"yes"=>true},
         "mobilePhone"=>"(303) 555-1234"},
       :metadata=>{:version=>0, :prefill=>true, :returnUrl=>"/applicant/information"}}
      )
      form_id = params[:id]
      form = InProgressForm.form_for_user(form_id, @current_user)
      if form
        render json: form.data_and_metadata
      elsif @current_user.can_access_prefill_data?
        render json: FormProfile.for(form_id).prefill(@current_user)
      else
        head 404
      end
    end

    def update
      form = InProgressForm.where(form_id: params[:id], user_uuid: @current_user.uuid).first_or_initialize
      form.update!(form_data: params[:form_data], metadata: params[:metadata])
      render json: form
    end

    def destroy
      form = InProgressForm.form_for_user(params[:id], @current_user)
      raise Common::Exceptions::RecordNotFound, params[:id] if form.blank?
      form.destroy
      render json: form
    end

    private

    def check_access_denied
      return if @current_user.can_save_partial_forms?
      raise Common::Exceptions::Unauthorized, detail: 'You do not have access to save in progress forms'
    end
  end
end
