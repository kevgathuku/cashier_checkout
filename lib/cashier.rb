require "cashier/version"

module Cashier
  class Error < StandardError; end
  class InvalidItemError < StandardError; end

  # Your code goes here...
end

require_relative "cashier/checkout"
