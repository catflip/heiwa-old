class CubicEasing < Easing
  def animate_in(progress)
    progress**3
  end

  def animate_out(progress)
    ((progress - 1)**3) + 1
  end

  def animate_in_out(progress)
    progress < 0.5 ? 4 * (progress**3) : 1 - ((((-2 * progress) + 2)**3) / 2)
  end
end
