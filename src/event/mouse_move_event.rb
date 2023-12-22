class MouseMoveEvent < Event
  attr_reader :x, :y, :x_relative, :y_relative

  def initialize(options)
    super(options)

    @x = options[:x] || 0
    @y = options[:y] || 0
    @x_relative = options[:x_relative] || 0
    @y_relative = options[:y_relative] || 0
  end
end
