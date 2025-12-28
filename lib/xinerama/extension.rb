# frozen_string_literal: true

module Xinerama
  class Extension
    attr_reader :event_base, :error_base

    def initialize(event_base:, error_base:)
      @event_base = event_base
      @error_base = error_base
      freeze
    end

    def to_h
      { event_base: event_base, error_base: error_base }
    end

    def inspect
      "#<#{self.class} event_base=#{event_base} error_base=#{error_base}>"
    end

    alias_method :to_s, :inspect
  end

  class Version
    attr_reader :major, :minor

    def initialize(major:, minor:)
      @major = major
      @minor = minor
      freeze
    end

    def to_s
      "#{major}.#{minor}"
    end

    def to_a
      [major, minor]
    end

    def to_h
      { major: major, minor: minor }
    end

    def inspect
      "#<#{self.class} #{self}>"
    end

    def <=>(other)
      [major, minor] <=> [other.major, other.minor]
    end

    include Comparable
  end
end
