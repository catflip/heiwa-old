require_relative 'component'

class Rectangle < Component
  attr_accessor :width, :height, :color

  # Creates a Rectangle.
  #
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  # @param [Color] color
  # @param [Array<Component>] children
  def initialize(
    x: 0, y: 0,
    width: 0, height: 0,
    color: Color.new(255, 255, 255, 255),
    children: []
  )
    super(x:, y:, children:)

    @width = width
    @height = height
    @color = color
  end

  def render(renderer)
    Architect.render_draw_color(renderer, *@color.to_a)
    Architect.render_rectangle(renderer, @x, @y, @width, @height)

    # Draw children
    children.each { |c| c.render(renderer) }
  end
end
