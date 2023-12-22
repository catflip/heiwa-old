class Window
  attr_reader :window_ptr, :renderer

  # @type [Object] The window pointer
  @window_ptr = nil

  # @type [Object] The renderer pointer
  @renderer = nil

  def initialize(options)
    options[:title] ||= ''
    options[:x] ||= 0
    options[:y] ||= 0
    options[:width] ||= 512
    options[:height] ||= 512
    options[:background_color] ||= Color.new(0, 0, 0, 255)

    options[:width] = Screen.width if options[:width] == :max
    options[:height] = Screen.height if options[:height] == :max

    @options = options

    initialize_window
  end

  def initialize_window
    # @type [Array<Proc>]
    post_actions = []

    # Set hints if needed
    if @options[:type] == :dock
      Architect.set_hint('SDL_X11_WINDOW_TYPE', '_NET_WM_WINDOW_TYPE_DOCK')
      post_actions << -> { Architect.set_hint('SDL_HINT_X11_WINDOW_TYPE', '') }
    end

    # Stop disabling the compositor
    Architect.set_hint('SDL_VIDEO_X11_NET_WM_BYPASS_COMPOSITOR', '0')

    # Spawn windows
    @window_ptr = Architect.create_window(@options)

    # Create the renderer
    @renderer = Architect.create_renderer(@window_ptr)

    # Run post actions
    post_actions.each(&:call)
  end

  def render
    # Clear the screen using the background color
    Architect.render_draw_color(@renderer, *@options[:background_color].to_a)
    Architect.render_clear @renderer

    yield

    Architect.render_present @renderer

    Architect.render_delay(1000 / 60)
  end
end
