require_relative 'architect/architect'

module Architect
  # @!method self.ping()
  #   Test method. Will return "Pong!" if successful.
  #   @return [String]

  # @!method self.gl_init()
  #   Initializes GLFW.
  #   @return [Object]

  # @!method self.gl_primary_monitor()
  #   Returns the primary monitor.
  #   @return [Object]

  # @!method self.create_window(options)
  #   Creates a window.
  #   @param [Hash] options
  #   @option options [Integer] :width The window width.
  #   @option options [Integer] :height The window width.
  #   @option options [String] :title The window title.
end

module Screen
  # @!method self.screen_size(monitor)
  #   Returns the screen size of a monitor.
  #   @param [Object] monitor
  #   @return [Hash] A hash with the `:width` and `:height` keys.

  # Returns the width of a monitor.
  # @param [Object] monitor
  # @return [Integer]
  def self.width(monitor)
    screen_size(monitor)[:width]
  end

  # Returns the height of a monitor.
  # @param [Object] monitor
  # @return [Integer]
  def self.height(monitor)
    screen_size(monitor)[:height]
  end
end
