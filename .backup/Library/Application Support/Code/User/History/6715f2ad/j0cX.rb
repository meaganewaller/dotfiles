# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'
require 'faraday'
require 'typed_struct_helper'
require 'active_support'
require 'active_support/number_helper'
require 'active_support/core_ext/string'
require 'reference_data'
require 'bigdecimal/util'

module Corpnet
  class Error < StandardError; end
  class UnauthorizedError < Error; end
  class InvalidOrderError < Error; end
  class NotFoundError < Error; end
  class NotImplementedError < Error; end
  class UnsupportedOrInvalidStateError < Error; end
  class InvalidTaxInfoError < Error; end

  # This is only set from CorpNet and they send it over as an array of error strings.
  class OrderArgumentsError < Error
    extend T::Sig

    sig { returns(T::Array[String]) }
    attr_reader :errors

    sig { params(errors: T::Array[String]).void }
    def initialize(errors)
      super('Error in order data')
      @errors = errors
    end

    sig { returns(String) }
    def message
      "#{super}: #{@errors.join(', ')}"
    end
  end

  class InternalServerError < Error; end
  class InvalidOrderResponseError < Error; end
  class ServiceUnavailableError < Error; end

  PARTNER_ID = T.let('10181', String)

  autoload :Api, File.expand_path('corpnet/api', __dir__)
  autoload :ApiConnectionMiddleware, File.expand_path('corpnet/api_connection_middleware', __dir__)
  autoload :ApiMode, File.expand_path('corpnet/api_mode', __dir__)
  autoload :ApiParserMiddleware, File.expand_path('corpnet/api_parser_middleware', __dir__)
  autoload :Common, File.expand_path('corpnet/common', __dir__)
  autoload :OrderData, File.expand_path('corpnet/order_data', __dir__)
  autoload :OrderStatus, File.expand_path('corpnet/order_status', __dir__)
end
