require_relative 'reactivity/reactive'
require_relative 'reactivity/computed'

# Total list of registered widgets.
# @type [Array<Widget>]
$WIDGETS = {}

class Widget
  attr_reader :options, :components, :events

  def initialize(options, components)
    @options = options
    @components = components

    # @type [Array<Proc>]
    @events = []
  end

  def add_component(component)
    @components << component
  end

  # Runs before every render tick
  def update
    event = Architect.poll_event
    return if event.nil?

    # @type [Event]
    event = Event.from_hash(event)

    # Skip handling the event if we don't have one to call
    unless event.nil?
      @events
        .filter { |ev| ev[:type] == event.type }
        .each do |ev|
        ev[:block].call event
      end
    end

    update
  end

  # Add a new event
  def register_event(id, type, block)
    @events << { id:, type:, block: }
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
    root: Root,
    rect: Rectangle,
    text: Text
  }

  # Create the component
  # @type [Component]
  component = component_map[component].new(**options)

  # Set the widget
  component.widget = $WIDGETS[$WIDGET_BUFFER]

  # Children proxy
  # This is required since we must use the `add_child` method on the component
  # instead, since it will set the `@parent` of the child element.
  children = []

  yield(component, children) if block_given?

  children.each do |c|
    component.add_child(c)
  end

  component
end

# Creates a `Root` component.
# This is simply a helper method to place components in without
# explicitly adding it to the widget root.
#
# `add_to_root` musn't be called. It is implicitly added to the root.
def root(&)
  raise 'There must only be one Root component.' if $__HAS_ROOT == true

  $__HAS_ROOT = true

  # @type [Root]
  component = make(:root, {}, &)
  component.add_to_root
end
