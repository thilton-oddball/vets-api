# frozen_string_literal: true

class FormProfiles::VA1995_STEM < FormProfile
  def metadata
    {
      version: 0,
      prefill: true,
      returnUrl: '/applicant/information'
    }
  end
end
