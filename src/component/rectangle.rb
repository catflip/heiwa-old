class Rectangle < Component
  include DynamicSize
  include DynamicPosition
  include EventHandler
  include Bounds

  reactive_accessor :width, :height, :color, :rounding

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
      { width: 0, height: 0, rounding: nil, color: Color.new(255, 255, 255) },
      force: true
    )

    super(options)
  end

  def render(renderer)
    # Dynamic position
    pos_x, pos_y = position == :dynamic ? [dynamic_x, dynamic_y] : [x, y]

    Architect.render_draw_color(renderer, *color.to_a)

    if rounding.nil?
      Architect.render_rectangle(renderer, pos_x, pos_y, dynamic_width, dynamic_height)
    else
      Architect.render_rounded_rectangle(renderer, pos_x, pos_y, dynamic_width, dynamic_height, rounding)
    end

    # Draw children
    children.each { |c| c.render(renderer) }
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
