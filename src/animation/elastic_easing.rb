class ElasticEasing < Easing
  ELASTIC_SINGLE_CONST = (2 * Math::PI) / 3
  ELASTIC_DUAL_CONST = (2 * Math::PI) / 4.5

  def initialize(options = {})
    @amplitude = [options[:amplitude] || 1, 1].max
    @period = options[:period] || 0.3

    @angular_frequency = @period / @amplitude
    @phase_offset = @angular_frequency / (2 * Math::PI) * Math.asin(1 / @amplitude)
    @angular_frequency = 2 * Math::PI / @angular_frequency

    super()
  end

  private

  def animate_in(progress)
    -(@amplitude * (2**(10 * (progress - 1))) * Math.sin((progress - @phase_offset) * @angular_frequency))
  end

  def animate_out(progress)
    (@amplitude * (2**(-10 * progress)) * Math.sin((progress - @phase_offset) * @angular_frequency)) + 1
  end

  def animate_in_out(progress)
    progress *= 2
    if progress < 1
      -0.5 * (@amplitude * (2**(10 * (progress - 1))) * Math.sin((progress - @phase_offset) * @angular_frequency))
    else
      (@amplitude * (2**(-10 * (progress - 1))) * Math.sin((progress - @phase_offset) * @angular_frequency) * 0.5) + 1
    end
  end
end
