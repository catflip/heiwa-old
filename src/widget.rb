require 'pathname'

require_relative 'reactivity/reactive'
require_relative 'reactivity/computed'
require_relative 'reactivity/watch'

# Total list of registered widgets.
# @type [Array<Widget>]
$WIDGETS = {}

class Widget
  attr_reader :options, :components, :components_array, :events
  attr_accessor :has_root, :window

  def initialize(options, components)
    @options = options

    # @type [Hash]
    @components = components

    # @type [Array<Component>]
    @components_array = []
    cache_components

    # @type [Array<Proc>]
    @events = []

    @has_root = false
  end

  # Adds a component to the widget
  def add_component(id, component, sort: true)
    @components[id] = component
    @components_array << component
    @components_array.sort_by!(&:z) if sort
  end

  # Removes a component from the widget
  def remove_component(id)
    @components[id]
    @components_array.delete_if { |c| c.id == id }
  end

  # Turns the current component hash into an array
  def cache_components
    @components_array = @components.values
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
def load_widget(name, path)
  widget_path = widget_path(path)
  $WIDGETS[widget_path] = [name, nil]

  # Load the widget
  require path
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
  widget_path = widget_path(caller_locations(1, 1).first.absolute_path)

  $WIDGETS[widget_path][1] = Widget.new(options, {})
end

# Create a component.
# @param [Symbol] component The component you'd like to create.
#   Valid components are: `:rect`
# @param [Hash] options The options related to the component.
def make(component, options, widget = nil)
  widget_path = widget_path(caller_locations(1, 1).first.absolute_path)

  if widget.nil?
    widget_name, widget = $WIDGETS[widget_path]
    raise "Your widget (#{widget_name}) was not initialized yet!" if widget.nil?
  end

  component_map = {
    root: Root,
    rect: Rectangle,
    text: Text,
    box: Box
  }

  # Create the component
  # @type [Component]
  component = component_map[component].new(**options)

  # Set the widget
  component.widget = widget

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
  widget_path = widget_path(caller_locations(1, 1).first.absolute_path)
  widget_name, widget = $WIDGETS[widget_path]

  raise 'There must only be one Root component.' if widget.has_root == true

  widget.has_root = true

  raise "Your widget (#{widget_name}) was not initialized yet!" if widget.nil?

  # @type [Root]
  component = make(:root, {}, widget, &)
  component.add_to_root
end

def widget_path(caller_path)
  config_dir = Pathname.new(File.expand_path('~/.config/heiwa/'))
  caller_path = Pathname.new(caller_path)
  caller_path.ascend do |path|
    break path if config_dir == path.parent
  end
end
