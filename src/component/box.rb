class Box < Component
  include DynamicSize
  include DynamicPosition
  include EventHandler

  reactive_reader :width, :height
  reactive_accessor :direction, :gap

  # Creates a box.
  #
  # @param [Hash] options
  # @option options [Integer] :x
  # @option options [Integer] :y
  # @option options [Integer] :gap
  # @option options [Array<Component>] :children
  def initialize(options)
    set(
      { direction: :row, gap: 0 },
      force: true
    )

    super(options)

    @width = computed do
      children.map do |c|
        (c&.dynamic_x || c&.x || 0) +
          (c&.dynamic_width || c&.width || 0)
      end.max
    end

    @height = computed do
      children.map do |c|
        (c&.dynamic_y || c&.y || 0) +
          (c&.dynamic_height || c&.height || 0)
      end.max
    end
  end

  def child_x(comp)
    index = child_index(comp)
    return dynamic_x + comp.x if direction == :column || index.nil?

    dynamic_x + children.slice(0, index).map do |c|
      (c&.x || 0) +
        (c&.dynamic_width || c&.width || 0) + gap
    end.sum + comp.x
  end

  def child_y(comp)
    index = child_index(comp)
    return dynamic_y + comp.y if direction == :row || index.nil?

    dynamic_y + children.slice(0, index).map do |c|
      (c&.y || 0) +
        (c&.dynamic_height || c&.height || 0) + gap
    end.sum + comp.y
  end

  private

  def child_index(comp)
    children.index(comp)
  end
end
