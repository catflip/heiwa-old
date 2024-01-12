class Component
  extend ReactiveAccessor
  include UnwrapReactive
  include UnwrapComputed

  reactive_accessor :x, :y, :children, :parent, :widget, :position

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
    set(
      {
        x: 0, y: 0,
        children: [],
        position: :dynamic,
        parent: nil, widget: nil
      },
      force: true
    )
    set(options)
  end

  # Sets filtered properties on the current component.
  #
  # @param [Hash] params The properties to set.
  def set(params, force: false)
    unless force
      # Any prop is valid as long as a class variable and a setter method exists.
      valid_keys = params.keys.filter do |key|
        instance_variable_defined?(:"@#{key}") && methods.include?(:"#{key}=")
      end

      params.filter! { |k, _| valid_keys.include? k }
    end

    params.each do |k, v|
      unless v.is_a?(Reactive) || v.is_a?(Computed)
        var = instance_variable_get(:"@#{k}")
        if var.is_a?(Reactive) || var.is_a?(Computed)
          # Assign it to the already existing Reactive variable
          var.value = v
          next
        else
          # Make `v` a Reactive variable
          v = reactive(v)
        end
      end

      instance_variable_set(:"@#{k}", v)
    end
  end

  # Get the raw `Reactive` variable from the component.
  # @param [Symbol] name The name of the variable.
  def get(name)
    instance_variable_get(:"@#{name}")
  end

  def render(_renderer)
    raise 'Render method must be defined!'
  end

  # Adds the component to the root tree.
  def add_to_root
    widget.add_component(self)
  end

  # Adds a child to the `children` array
  def add_child(component)
    component.parent = self
    component.widget = @widget
    children << component
  end
end
