class Root < Component
  include EventHandler

  def initialize
    super({ x: 0, y: 0 })
  end

  def render(renderer)
    children.each { |c| c.render(renderer) }
  end
end
