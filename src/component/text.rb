class Text < Component
  include DynamicSize
  include DynamicPosition
  include EventHandler

  reactive_accessor :content, :font, :color, :size
  reactive_reader :width

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
      {
        content: '', font: nil, size: 16, width: 0,
        color: Color.new(255, 255, 255)
      },
      force: true
    )

    super(options)

    @font_family = font.open(size)

    # Update text width
    watch(@content) { update_width }
    update_width
  end

  def render(renderer)
    # Dynamic position
    pos_x, pos_y = position == :dynamic ? [dynamic_x, dynamic_y] : [x, y]

    Architect.render_draw_color(renderer, *color.to_a)
    Architect.render_text(renderer, pos_x, pos_y, content, @font_family)
  end

  private

  def update_width
    @width.value = Architect.text_width(@font_family, content)
  end
end
