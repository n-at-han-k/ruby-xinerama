# frozen_string_literal: true

module Xinerama
  class ScreenInfo
    attr_reader :screen_number, :x, :y, :width, :height

    def initialize(screen_number:, x:, y:, width:, height:)
      @screen_number = screen_number
      @x = x
      @y = y
      @width = width
      @height = height
      freeze
    end

    def origin
      [x, y]
    end

    def dimensions
      [width, height]
    end

    def area
      width * height
    end

    def aspect_ratio
      Rational(width, height)
    end

    def contains?(point_x, point_y)
      point_x >= x && point_x < (x + width) &&
        point_y >= y && point_y < (y + height)
    end

    def to_h
      {
        screen_number: screen_number,
        x: x,
        y: y,
        width: width,
        height: height
      }
    end

    def to_a
      [screen_number, x, y, width, height]
    end

    def inspect
      "#<#{self.class} screen=#{screen_number} geometry=#{width}x#{height}+#{x}+#{y}>"
    end

    alias_method :to_s, :inspect

    def ==(other)
      other.is_a?(ScreenInfo) &&
        screen_number == other.screen_number &&
        x == other.x &&
        y == other.y &&
        width == other.width &&
        height == other.height
    end

    alias_method :eql?, :==

    def hash
      to_a.hash
    end

    class << self
      def from_struct(struct)
        new(
          screen_number: struct[:screen_number],
          x: struct[:x_org],
          y: struct[:y_org],
          width: struct[:width],
          height: struct[:height]
        )
      end

      def from_pointer(pointer, count)
        Enumerator.new do |yielder|
          count.times do |index|
            offset = index * FFI::XineramaScreenInfoStruct.size
            struct = FFI::XineramaScreenInfoStruct.new(pointer + offset)
            yielder << from_struct(struct)
          end
        end.lazy
      end
    end
  end
end
