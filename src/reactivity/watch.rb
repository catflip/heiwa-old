class Watcher
  # Create a Watcher.
  #
  # @param [Reactive, Computed] value The value to watch
  # @param [Proc] block The block to execute
  def initialize(value, &block)
    unless value.is_a?(Reactive) || value.is_a?(Computed)
      raise "Can't watch a non-reactive value (type #{value.class})!"
    end

    @reactive_value = value
    @block = block
    @previous = nil

    @reactive_value.add_watcher self
  end

  # Update the watcher with a value
  def update(value)
    return if value == @previous

    @block.call(value, @previous)
    @previous = value
  end

  # Detach the watcher from the value
  def detach
    @reactive_value.remove_watcher self
  end
end

# Create a Watcher for reactive values.
# @param [Reactive, Computed] value The reactive value you want to watch.
def watch(value, &)
  Watcher.new(value, &)
end
