# frozen_string_literal: true

module Facilities
  class VHAFacility < BaseFacility
    has_many :drivetime_bands
  end
end
