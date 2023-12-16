require_relative 'architect/architect'

module Architect
  # @!method self.ping()
  #   Test method. Will return "Pong!" if successful.
  #   @return [String]

  # @!method self.init_sdl()
  #   Initializes SDL (using SDL_INIT_EVERYTHING).

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
end
