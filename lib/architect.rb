require_relative 'architect/architect'

module Architect
  # @!method self.ping()
  #   Test method. Will return "Pong!" if successful.
  #   @return [String]

  ##
  ## OpenGL methods
  ##

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

  # @!method self.gl_make_context(window)
  #   Sets the current context to the one provided.
  #   @param [Object] window

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

  # @!method self.gl_bind_vertex_array(vao)
  #   Binds a VAO.
  #   @param [Object] vao

  # @!method self.gl_draw_arrays(mode, first, count)
  #   Draws the current VBO.
  #   @param [Symbol] mode The draw mode.
  #     Valid options are: `:points`, `:triangles`.
  #   @param [Integer] first Starting index.
  #   @param [Integer] count Number of verts.

  # @!method self.gl_draw_elements(mode, count, type, indices)
  #   Draws the current EBO.
  #   @param [Symbol] mode The draw mode.
  #     Valid options are: `:points`, `:triangles`.
  #   @param [Integer] count Number of verts.
  #   @param [Symbol] type The indices type.
  #     Valid options are: `:unsigned_int`.
  #   @param [Object, NilClass] indices Optional indices object.

  ##
  ## Shader methods
  ##

  # @!method self.compile_vertex_shader(source)
  #   Compiles a vertex shader.
  #   @param [String] source The vertex shader.
  #   @return [Object] The compiled shader.

  # @!method self.compile_fragment_shader(source)
  #   Compiles a fragment shader.
  #   @param [String] source The fragment shader.
  #   @return [Object] The compiled shader.

  # @!method self.delete_shader(shader)
  #   Deletes a compiled shader.
  #   @param [Object] shader The shader to delete.

  # @!method self.create_shader_program()
  #   Creates a shader program.
  #   @return [Object] The shader program.

  # @!method self.attach_shader_to(program, shader)
  #   Attaches a shader to a shader program.
  #   @param [Object] program The program to attach to.
  #   @param [Object] shader The shader to attach.

  # @!method self.link_shader_program(program)
  #   Links a shader program.
  #   @param [Object] program The program to link.

  # @!method self.use_shader_program(program)
  #   Uses a shader program.
  #   @param [Object] program The program to use.

  ##
  ## Geometry methods
  ##

  # @!method self.geometry_rectangle(options)
  # Returns the VBO and VAO for a rectangle.
  # @param [Hash] options The rectangle options.
  # @option options [Integer] x1
  # @option options [Integer] y1
  # @option options [Integer] x2
  # @option options [Integer] y2
  # @return [Hash] The VBO and VAO.

  ##
  ## Other
  ##

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
