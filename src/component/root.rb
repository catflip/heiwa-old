class Root < Component
  include DynamicSize
  include EventHandler

  reactive_accessor :width, :height

  def initialize
    set(
      { width: :max, height: :max },
      force: true
    )

    super({ x: 0, y: 0 })
  end

  def render(renderer)
    children.each { |c| c.render(renderer) }
  end
end
