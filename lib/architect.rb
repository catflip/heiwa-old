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

  # @!method self.gl_viewport(options)
  #   Sets the current GL viewport.
  #   @param [Hash] options
  #   @option options [Integer] :x
  #   @option options [Integer] :y
  #   @option options [Integer] :width
  #   @option options [Integer] :height

  # @!method self.gl_swap_buffers(window)
  #   Swaps the GL buffer on a window.
  #   @param [Object] window

  # @!method self.gl_poll_events()
  #   Polls GL events.

  # @!method self.gl_clear_color(color)
  #   Sets the GL clear color.
  #   @param [Array<Float>] color RGBA colors in an array.

  # @!method self.gl_clear(mask)
  #   Clears the screen.
  #   @param [Symbol] mask The mask to use.
  #     Valid options are: `:color_buffer_bit`

  # @!method self.gl_make_context(window)
  #   Sets the current context to the one provided.
  #   @param [Object] window

  # @!method self.create_window(options)
  #   Creates a window.
  #   @param [Hash] options
  #   @option options [Integer] :width The window width.
  #   @option options [Integer] :height The window width.
  #   @option options [String] :title The window title.

  # Gets the elapsed time via $__TIMER or the `timer` parameter (if it exists).
  # Returns nil if if $__TIMER is `nil`.
  # @return [Integer, NilClass]
  def self.get_ticks(timer = nil)
    timer ||= $__TIMER
    return nil if timer.nil?

    time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    ((time - timer) * 1000).round
  end
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
