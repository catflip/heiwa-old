require_relative 'architect/architect'

module Architect
  # @!method self.ping()
  #   Test method. Will return "Pong!" if successful.
  #   @return [String]

  # @!method self.init_sdl()
  #   Initializes SDL (using SDL_INIT_EVERYTHING).

  # @!method self.set_hint(name, value)
  #   Set an SDL hint.

  # @!method self.create_window(window_params)
  #   Creates an SDL window and returns the pointer.
  #   @param [Hash] window_params
  #   @option window_params [String] :title The title of the window.
  #   @option window_params [Integer] :width The width of the window.
  #   @option window_params [Integer] :height The height of the window.
  #   @return [Object]

  # @!method self.create_renderer(window)
  #   Creates an SDL renderer and returns the pointer.
  #   @param [Object] window The window to create the renderer for.
  #   @return [Object]

  # @!method self.render_clear(renderer)
  #   Clears the renderer buffer.
  #   @param [Object] renderer

  # @!method self.render_present(renderer)
  #   Presents the renderer buffer.
  #   @param [Object] renderer

  # @!method self.render_draw_color(renderer, r, g, b, a)
  #   Sets the current draw color.
  #   @param [Object] renderer
  #   @param [Integer] r Red
  #   @param [Integer] g Green
  #   @param [Integer] b Blue
  #   @param [Integer] a Alpha

  # @!method self.render_rectangle(renderer, x, y, w, h)
  #   Renders a rectangle.
  #   @param [Object] renderer
  #   @param [Integer] x
  #   @param [Integer] y
  #   @param [Integer] w Width
  #   @param [Integer] h Height

  # @!method self.render_rounded_rectangle(renderer, x, y, w, h, r)
  #   Renders a rounded rectangle.
  #   @param [Object] renderer
  #   @param [Integer] x
  #   @param [Integer] y
  #   @param [Integer] w Width
  #   @param [Integer] h Height
  #   @param [Integer] r Rounding

  # @!method self.render_cleanup()
  #   Cleans up a renderer and a window object. Does not exit SDL.
  #   @param [Object] window
  #   @param [Object] renderer

  # @!method self.poll_event()
  #   Polls an SDL_Event. Returns a custom event schema.
  #   @return [Hash]
end

module Screen
  # @!method self.size(display_index)
  #   Gets the size of the screen at `display_index`.
  #   @param [Integer] display_index
  #   @return [Hash] The `width` and `height` in a hash.

  def self.width(display_index)
    size(display_index)[:width]
  end

  def self.height(display_index)
    size(display_index)[:height]
  end
end
