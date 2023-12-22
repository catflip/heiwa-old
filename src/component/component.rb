class Component
  include UnwrapReactive
  include UnwrapComputed

  attr_accessor :x, :y, :children, :parent, :widget, :position

  # Creates an empty component.
  # This will do nothing in itself and will not render.
  #
  # @param [Hash] options
  # @option options [Integer] :x
  # @option options [Integer] :y
  # @option options [Array<Component>] :children
  # @option options [Component] :parent
  # @option options [Symbol] :position
  #   Valid options are `:absolute` or `:dynamic`.
  def initialize(options)
    @x = 0
    @y = 0
    @children = []
    @position = :dynamic
    @parent = nil
    @widget = nil

    set(options)
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

  # Unwrap a variable in the component
  def get(value)
    if value.is_a? Reactive
      unwrap_reactive value
    elsif value.is_a? Computed
      unwrap_computed value
    else
      value
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
    component.widget = @widget
    @children << component
  end
end
