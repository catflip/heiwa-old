require_relative 'watchable'

module UnwrapReactive
  # @param [Reactive] reactive
  def unwrap_reactive(reactive)
    reactive.value
  end
end

class Reactive
  include Watchable

  attr_reader :value

  def initialize(value)
    @value = value
  end

  def value=(new_value)
    @value = new_value
    update_watchers(@value)
  end
end

# Create a new reactive variable.
def reactive(val)
  Reactive.new val
end
