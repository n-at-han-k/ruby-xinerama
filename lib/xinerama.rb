# frozen_string_literal: true

require_relative "xinerama/version"
require_relative "xinerama/ffi"
require_relative "xinerama/screen_info"
require_relative "xinerama/display"
require_relative "xinerama/extension"

module Xinerama
  class Error < StandardError; end
  class NotAvailableError < Error; end
  class DisplayError < Error; end

  class << self
    def open(display_name = nil, &block)
      Display.open(display_name, &block)
    end

    def screens(display_name = nil)
      Display.open(display_name, &:screens)
    end

    def active?(display_name = nil)
      Display.open(display_name, &:active?)
    end

    def version(display_name = nil)
      Display.open(display_name, &:version)
    end
  end
end
