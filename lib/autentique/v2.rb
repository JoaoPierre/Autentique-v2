# frozen_string_literal: true

require_relative 'v2/client'
require_relative 'v2/mutations/documents'
require_relative 'v2/mutations/signatures'
require_relative 'v2/mutations/biometric_verifications'
require_relative 'v2/version'

module Autentique
  module V2
    class Error < StandardError; end
    # Your code goes here...
  end
end
