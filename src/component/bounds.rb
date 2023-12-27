# A small module for calculating position and size related things.
module Bounds
  def within_bounds?(position_x, position_y)
    if  !instance_variable_defined?(:@x) ||
        !instance_variable_defined?(:@y) ||
        @x.nil? || @y.nil?
      raise 'Cannot calculate bounds without `@x` and `@y`!'
    end

    if  !instance_variable_defined?(:@width) ||
        !instance_variable_defined?(:@height) ||
        @width.nil? || @height.nil?
      raise 'Cannot calculate bounds without `@width` and `@height`!'
    end

    x <= position_x && position_x <= x + width && y <= position_y && position_y <= y + height
  end
end
