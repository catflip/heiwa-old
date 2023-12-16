require_relative 'component/component'
require_relative 'component/rectangle'

# We don't really need these requires, but they are needed for widgets.
require_relative 'util'

# Total list of registered widgets.
# @type [Array<Widget>]
$WIDGETS = {}

class Widget
  attr_reader :options, :components

  def initialize(options, components)
    @options = options
    @components = components
  end

  def add_component(component)
    @components << component
  end
end

# Loads a widget by a name and a path.
# $WIDGET_BUFFER will be the name until the loading finishes.
def load_widget(name, path)
  $WIDGET_BUFFER = name

  # Load the widget
  require path

  $WIDGET_BUFFER = nil
end

# You should pass information about your widget here.
# @param [Hash] options
# @option options [String] :title The title of your widget.
# @option options [Integer] :x The X position of your widget.
# @option options [Integer] :y The Y position of your widget.
# @option options [Integer] :width The width of your widget.
# @option options [Integer] :height The height of your widget.
# @option options [Symbol] :type The type of your widget.
#   - `:window` will create a floating window.
#   - `:dock` will create a docked window.
def make_widget(options)
  $WIDGETS[$WIDGET_BUFFER] = Widget.new(options, [])
end

# Create a component.
# @param [Symbol] component The component you'd like to create.
#   Valid components are: `:rect`
# @param [Hash] options The options related to the component.
def make(component, options)
  component_map = {
    rect: Rectangle
  }

  # Create the component
  component = component_map[component].new(**options)

  yield(component, component.children) if block_given?

  component
end
