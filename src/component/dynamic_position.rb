# A helper module for setting a dynamic position.
# This will set the position anchor (which is `[0, 0]` by default) to the
# parent's position.
#
# For example, if the parent has a position of `[10, 10]`, and the current
# element has a dynamic position of `[15, 15]`, the rendered position
# will be at `[25, 25]`.
#
# Position anchors are inherited from the nearest element.
module DynamicPosition
  def dynamic_x
    if !instance_variable_defined?(:@x) || @x.nil?
      raise 'Cannot use `dynamic_x` without `@x`. Does your component support `@x`?'
    end

    @parent.nil? ? x : parent.x + x
  end

  def dynamic_y
    if !instance_variable_defined?(:@y) || @y.nil?
      raise 'Cannot use `dynamic_y` without `@y`. Does your component support `@y`?'
    end

    parent.nil? ? y : parent.y + y
  end
end
