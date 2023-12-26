class Text < Component
  include DynamicSize
  include DynamicPosition
  include EventHandler

  reactive_accessor :content, :font, :color, :size

  # Creates Text.
  #
  # @param [Hash] options
  # @option options [Integer] :x
  # @option options [Integer] :y
  # @option options [String] :content
  # @option options [String] :font
  # @option options [Integer] :size
  # @option options [Color] :color
  def initialize(options)
    set(
      { content: '', font: nil, size: 16, color: Color.new(255, 255, 255) },
      force: true
    )

    super(options)
  end

  def render(renderer)
    # Dynamic position
    pos_x, pos_y = position == :dynamic ? [dynamic_x, dynamic_y] : [x, y]
    font_family = font.open(size)

    Architect.render_draw_color(renderer, *color.to_a)
    Architect.render_text(renderer, pos_x, pos_y, content, font_family)
  end
end
