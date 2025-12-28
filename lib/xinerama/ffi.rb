# frozen_string_literal: true

require "ffi"

module Xinerama
  module FFI
    extend ::FFI::Library

    ffi_lib "X11"
    ffi_lib "Xinerama"

    # XineramaScreenInfo struct
    # typedef struct {
    #   int screen_number;
    #   short x_org;
    #   short y_org;
    #   short width;
    #   short height;
    # } XineramaScreenInfo;
    class XineramaScreenInfoStruct < ::FFI::Struct
      layout :screen_number, :int,
             :x_org,         :short,
             :y_org,         :short,
             :width,         :short,
             :height,        :short
    end

    # Display* XOpenDisplay(const char *display_name)
    attach_function :XOpenDisplay, [:string], :pointer

    # int XCloseDisplay(Display *display)
    attach_function :XCloseDisplay, [:pointer], :int

    # int XFree(void *data)
    attach_function :XFree, [:pointer], :int

    # Bool XineramaQueryExtension(Display *dpy, int *event_base_return, int *error_base_return)
    attach_function :XineramaQueryExtension, [:pointer, :pointer, :pointer], :bool

    # Status XineramaQueryVersion(Display *dpy, int *major_version_return, int *minor_version_return)
    attach_function :XineramaQueryVersion, [:pointer, :pointer, :pointer], :int

    # Bool XineramaIsActive(Display *dpy)
    attach_function :XineramaIsActive, [:pointer], :bool

    # XineramaScreenInfo* XineramaQueryScreens(Display *dpy, int *number)
    attach_function :XineramaQueryScreens, [:pointer, :pointer], :pointer
  end
end
