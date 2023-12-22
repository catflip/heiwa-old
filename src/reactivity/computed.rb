module UnwrapComputed
  # @param [Computed] computed
  def unwrap_computed(computed)
    computed.read
  end
end

class Computed
  attr_reader :computer

  def initialize(&computer)
    @computer = computer
  end

  def read
    @computer.call
  end
end

# Create a new computed variable.
def computed(&)
  Computed.new(&)
end
