require "cashier/version"

module Cashier
  class Error < StandardError; end
  class InvalidItemError < StandardError; end
  class InvalidRulesError < StandardError; end

  # Your code goes here...
end

require_relative "cashier/checkout"
