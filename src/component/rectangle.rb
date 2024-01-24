require_relative '../shaders/solid_shader'

class Rectangle < Component
  include DynamicSize
  include DynamicPosition
  include EventHandler
  include Bounds

  reactive_accessor :color, :rounding

  # Creates a Rectangle.
  #
  # @param [Hash] options
  # @option options [Integer] :x
  # @option options [Integer] :y
  # @option options [Integer] :width
  # @option options [Integer] :height
  # @option options [Integer] :rounding
  # @option options [Color] :color
  # @option options [Array<Component>] :children
  def initialize(
    options
  )
    set(
      { rounding: nil, color: Color.new(255, 255, 255) },
      force: true
    )

    super(options)

    @initialized = false
  end

  def after_init
    pos_x, pos_y = position == :dynamic ? [dynamic_x, dynamic_y] : [x, y]
    x1, y1 = Architect.normalized_coord(widget.window.window, pos_x, pos_y)
    x2, y2 = Architect.normalized_coord(widget.window.window, pos_x + width, pos_y + height)

    geometry = Architect.geometry_rectangle({ x1:, y1:, x2:, y2: })
    @vao = geometry[:vao]
    @vbo = geometry[:vbo]
    @shader = SolidShader.shader.program

    @initialized = true
  end

  def render
    after_init unless @initialized

    Architect.use_shader_program(@shader)
    loc = Architect.gl_uniform_location(@shader, 'color')

    colors = Architect.normalized_rgba(color.to_a)
    Architect.gl_uniform_4f(loc, colors)

    Architect.gl_bind_vertex_array(@vao)
    Architect.gl_draw_elements(:triangles, 6, :unsigned_int, nil)
    Architect.gl_bind_vertex_array(0)
  end

  def add_event(event, only_hover: true, &block)
    super(event) do |ev|
      # Return if it's a mouse event, hover_only is true, and the position is
      # not within the rectangle.
      next if %i[mouse_down mouse_up].include?(event) && only_hover == true && !(within_bounds? ev.x, ev.y)

      block.call ev
    end
  end
end
