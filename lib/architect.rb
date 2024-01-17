require_relative 'architect/architect'

module Architect
  # @!method self.ping()
  #   Test method. Will return "Pong!" if successful.
  #   @return [String]

  # @!method self.gl_init()
  #   Initializes GLFW.

  # @!method self.create_window(options)
  #   Creates a window.
  #   @param [Hash] options
  #   @option options [Integer] :width The window width.
  #   @option options [Integer] :height The window width.
  #   @option options [String] :title The window title.
end

module Screen
  # def self.width(display_index)
  #   size(display_index)[:width]
  # end

  # def self.height(display_index)
  #   size(display_index)[:height]
  # end
end
