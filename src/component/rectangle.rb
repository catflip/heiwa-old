require_relative 'component'
require_relative 'dynamic_size'
require_relative 'dynamic_position'

class Rectangle < Component
  include DynamicSize
  include DynamicPosition

  attr_accessor :width, :height, :color

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
    super(x: options[:x], y: options[:y], children: options[:children])

    @width = options[:width] || 0
    @height = options[:height] || 0
    @rounding = options[:rounding]
    @color = options[:color] || Color.new(255, 255, 255, 255)
  end

  def render(renderer)
    # Dynamic position
    x, y = position == :dynamic ? [dynamic_x, dynamic_y] : [@x, @y]

    Architect.render_draw_color(renderer, *@color.to_a)

    if @rounding.nil?
      Architect.render_rectangle(renderer, x, y, dynamic_width, dynamic_height)
    else
      Architect.render_rounded_rectangle(renderer, x, y, dynamic_width, dynamic_height, @rounding)
    end

    # Draw children
    children.each { |c| c.render(renderer) }
  end
end
