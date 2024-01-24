class Window
  attr_reader :window_id, :window

  # @type [Integer] The window ID
  @window_id = -1

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
    @window_id, @window = Architect.create_window(@options)

    # Run post actions
    post_actions.each(&:call)
  end

  def render
    Architect.gl_make_context(@window)

    # Clear the screen using the background color
    Architect.gl_clear_color(Architect.normalized_rgba(@options[:background_color].to_a))
    Architect.gl_clear(:color_buffer_bit)

    yield

    Architect.gl_swap_buffers(@window)
    Architect.gl_poll_events
  end

  def exit
    # Architect.render_cleanup(@window, @renderer)
  end
end
