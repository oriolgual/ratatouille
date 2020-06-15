# frozen_string_literal: true

require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem
loader.enable_reloading
loader.setup

require "ratatouille/version"

module Ratatouille
  class Error < StandardError; end
  # Your code goes here...
end
