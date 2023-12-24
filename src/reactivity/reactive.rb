module UnwrapReactive  
  # @param [Reactive] reactive
  def unwrap_reactive(reactive)
    reactive.value
  end
end

class Reactive
  attr_accessor :value

  def initialize(value)
    @value = value
  end
end

# Create a new reactive variable.
def reactive(val)
  Reactive.new val
end
