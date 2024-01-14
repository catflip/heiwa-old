class Text < Component
  include DynamicSize
  include DynamicPosition
  include EventHandler

  reactive_accessor :content, :font, :color, :background_color, :size
  reactive_reader :width, :height

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
        content: '', font: nil, size: 16,
        width: 0, height: 0,
        color: Color.new(255, 255, 255),
        background_color: nil
      },
      force: true
    )

    super(options)

    @font_family = font.open(size)

    # Update text size
    watch(@content) { update_size }
    watch(@size) { update_size }
    update_size
  end

  def render(renderer)
    # Dynamic position
    pos_x, pos_y = position == :dynamic ? [dynamic_x, dynamic_y] : [x, y]

    unless background_color.nil?
      Architect.render_draw_color(renderer, *background_color.to_a)
      Architect.render_rectangle(renderer, pos_x, pos_y, width, height)
    end

    Architect.render_draw_color(renderer, *color.to_a)
    Architect.render_text(renderer, pos_x, pos_y, content, @font_family)
  end

  private

  def update_size
    @width.value = Architect.text_width(@font_family, content)
    @height.value = Architect.text_height(@font_family, content)
  end
end
