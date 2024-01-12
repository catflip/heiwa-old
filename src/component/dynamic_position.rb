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

    case parent
    when NilClass
      x
    when Box
      parent.child_x(self)
    else
      parent.x + x
    end
  end

  def dynamic_y
    if !instance_variable_defined?(:@y) || @y.nil?
      raise 'Cannot use `dynamic_y` without `@y`. Does your component support `@y`?'
    end

    case parent
    when NilClass
      y
    when Box
      parent.child_y(self)
    else
      parent.y + y
    end
  end
end
