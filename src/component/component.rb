class Component
  attr_accessor :x, :y, :children, :parent

  # Creates an empty component.
  # This will do nothing in itself and will not render.
  #
  # @param [Integer] x
  # @param [Integer] y
  # @param [Array<Component>] children
  # @param [Component] parent
  def initialize(x:, y:, children: [], parent: nil)
    @x = x
    @y = y
    @children = children
    @parent = parent
  end

  # Sets filtered properties on the current component.
  #
  # @param [Hash] params The properties to set.
  def set(params)
    # Any prop is valid as long as a class variable and a setter method exists.
    valid_keys = params.keys.filter do |key|
      instance_variable_defined?(:"@#{key}") && methods.include?(:"#{key}=")
    end

    params.filter! { |k, _| valid_keys.include? k }
    params.each do |k, v|
      instance_variable_set(:"@#{k}", v)
    end
  end

  def render(_renderer)
    raise 'Render method must be defined!'
  end

  # Adds the component to the root tree.
  def add_to_root
    $WIDGETS[$WIDGET_BUFFER].add_component(self)
  end

  # Adds a child to the `children` array
  def add_child(component)
    component.parent = self
    children << component
  end
end
