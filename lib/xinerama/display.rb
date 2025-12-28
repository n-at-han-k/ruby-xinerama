# frozen_string_literal: true

module Xinerama
  class Display
    attr_reader :display_name

    def initialize(display_pointer, display_name = nil)
      @pointer = display_pointer
      @display_name = display_name
      @closed = false
    end

    def close
      return if @closed

      FFI.XCloseDisplay(@pointer)
      @closed = true
      nil
    end

    def closed?
      @closed
    end

    def extension
      ensure_open!
      @extension ||= query_extension
    end

    def available?
      ensure_open!
      @available ||= check_availability
    end

    def version
      ensure_open!
      @version ||= query_version
    end

    def active?
      ensure_open!
      FFI.XineramaIsActive(@pointer)
    end

    def screens
      ensure_open!
      query_screens
    end

    def primary_screen
      screens.first
    end

    def screen_count
      screens.count
    end

    def screen_at(x, y)
      screens.find { |screen| screen.contains?(x, y) }
    end

    def total_dimensions
      all_screens = screens.to_a
      return [0, 0] if all_screens.empty?

      max_x = all_screens.map { |s| s.x + s.width }.max
      max_y = all_screens.map { |s| s.y + s.height }.max
      [max_x, max_y]
    end

    class << self
      def open(display_name = nil)
        display = connect(display_name)
        return display unless block_given?

        begin
          yield display
        ensure
          display.close
        end
      end

      private

      def connect(display_name)
        pointer = FFI.XOpenDisplay(display_name)
        raise DisplayError, "Cannot open display: #{display_name || '$DISPLAY'}" if pointer.null?

        new(pointer, display_name)
      end
    end

    private

    def ensure_open!
      raise DisplayError, "Display connection closed" if @closed
    end

    def check_availability
      event_base = ::FFI::MemoryPointer.new(:int)
      error_base = ::FFI::MemoryPointer.new(:int)
      FFI.XineramaQueryExtension(@pointer, event_base, error_base)
    end

    def query_extension
      event_base = ::FFI::MemoryPointer.new(:int)
      error_base = ::FFI::MemoryPointer.new(:int)

      available = FFI.XineramaQueryExtension(@pointer, event_base, error_base)
      raise NotAvailableError, "Xinerama extension not available" unless available

      Extension.new(
        event_base: event_base.read_int,
        error_base: error_base.read_int
      )
    end

    def query_version
      major = ::FFI::MemoryPointer.new(:int)
      minor = ::FFI::MemoryPointer.new(:int)

      status = FFI.XineramaQueryVersion(@pointer, major, minor)
      raise NotAvailableError, "Cannot query Xinerama version" if status.zero?

      Version.new(
        major: major.read_int,
        minor: minor.read_int
      )
    end

    def query_screens
      count_ptr = ::FFI::MemoryPointer.new(:int)
      screens_ptr = FFI.XineramaQueryScreens(@pointer, count_ptr)
      count = count_ptr.read_int

      return Enumerator.new { }.lazy if screens_ptr.null? || count.zero?

      build_screens_enumerator(screens_ptr, count)
    end

    def build_screens_enumerator(screens_ptr, count)
      Enumerator.new do |yielder|
        begin
          ScreenInfo.from_pointer(screens_ptr, count).each do |screen|
            yielder << screen
          end
        ensure
          FFI.XFree(screens_ptr) unless screens_ptr.null?
        end
      end.lazy
    end
  end
end
