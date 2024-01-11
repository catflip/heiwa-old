class LinearEasing < Easing
  def animate(progress)
    progress
  end

  alias animate_in animate
  alias animate_out animate
  alias animate_in_out animate
end
