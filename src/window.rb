class Window
  attr_reader :window

  # @type [Object] The window pointer
  @window = nil

  def initialize(options)
    options[:title] ||= ''
    options[:x] ||= 0
    options[:y] ||= 0
    options[:width] ||= 512
    options[:height] ||= 512
    options[:background_color] ||= Color.new(0, 0, 0, 255)

    options[:width] = Screen.width(Architect.gl_primary_monitor) if options[:width] == :max
    options[:height] = Screen.height(Architect.gl_primary_monitor) if options[:height] == :max

    @options = options

    initialize_window
  end

  def initialize_window
    # @type [Array<Proc>]
    post_actions = []

    # Set hints if needed
    if @options[:type] == :dock
      # Architect.set_hint('SDL_X11_WINDOW_TYPE', '_NET_WM_WINDOW_TYPE_DOCK')
      # post_actions << -> { Architect.set_hint('SDL_HINT_X11_WINDOW_TYPE', '') }
    end

    # Stop disabling the compositor
    # Architect.set_hint('SDL_VIDEO_X11_NET_WM_BYPASS_COMPOSITOR', '0')

    # Spawn windows
    @window = Architect.create_window(@options)

    # Run post actions
    post_actions.each(&:call)

    # Default shaders
    vertex_shader = File.read(File.join(__dir__, 'shader', 'vertex.default.glsl'))
    fragment_shader = File.read(File.join(__dir__, 'shader', 'fragment.default.glsl'))

    vertex_shader = Architect.compile_vertex_shader(vertex_shader)
    fragment_shader = Architect.compile_fragment_shader(fragment_shader)

    @shader_program = Architect.create_shader_program
    Architect.attach_shader_to(@shader_program, vertex_shader)
    Architect.attach_shader_to(@shader_program, fragment_shader)
    Architect.link_shader_program(@shader_program)
    Architect.delete_shader(vertex_shader)
    Architect.delete_shader(fragment_shader)
  end

  def render
    Architect.gl_make_context(@window)

    # Clear the screen using the background color
    Architect.gl_clear_color([0.3, 0.3, 0.3, 1])
    Architect.gl_clear(:color_buffer_bit)

    Architect.use_shader_program(@shader_program)

    yield

    Architect.gl_swap_buffers(@window)
    Architect.gl_poll_events
  end

  def exit
    # Architect.render_cleanup(@window, @renderer)
  end
end
