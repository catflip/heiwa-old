require_relative 'component'
require_relative 'dynamic_size'

class Rectangle < Component
  include DynamicSize

  attr_accessor :width, :height, :color

  # Creates a Rectangle.
  #
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] width
  # @param [Integer] height
  # @param [Integer] rounding
  # @param [Color] color
  # @param [Array<Component>] children
  def initialize(
    x: 0, y: 0,
    width: 0, height: 0,
    rounding: nil,
    color: Color.new(255, 255, 255, 255),
    children: []
  )
    super(x:, y:, children:)

    @width = width
    @height = height
    @rounding = rounding
    @color = color
  end

  def render(renderer)
    Architect.render_draw_color(renderer, *@color.to_a)

    if @rounding.nil?
      Architect.render_rectangle(renderer, @x, @y, dynamic_width, dynamic_height)
    else
      Architect.render_rounded_rectangle(renderer, @x, @y, dynamic_width, dynamic_height, @rounding)
    end

    # Draw children
    children.each { |c| c.render(renderer) }
  end
end
