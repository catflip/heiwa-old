require_relative 'watchable'

module UnwrapComputed
  # @param [Computed] computed
  def unwrap_computed(computed)
    computed.read
  end
end

class Computed
  include Watchable

  attr_reader :computer

  def initialize(&computer)
    @computer = computer
  end

  def read
    value = @computer.call
    update_watchers(value)
    value
  end
end

# Create a new computed variable.
def computed(&)
  Computed.new(&)
end
