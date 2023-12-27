class Animation
  # Animate a numeric `Reactive` variable to another one.
  #
  # @param [Reactive] reactive The `Reactive` variable to animate
  # @param [Numeric] target The value to animate to
  # @param [Numeric] duration The duration of the animation in seconds
  # @param [Symbol] mode The mode of the easing.
  #   Accepted modes are: `:in`, `:out`, `:in_out`.
  #   `LinearAnimation` is not affected by this.
  def initialize(reactive, target, duration, mode: :out)
    @reactive = reactive
    @target = target
    @duration = duration
    @mode = mode

    @running = false
  end

  def start
    return if @running == true

    @running = true

    Thread.new do
      start_time = Time.now
      end_time = start_time + @duration
      @from = @reactive.value

      func =  case @mode
              when :in
                method(:animate_in)
              when :out
                method(:animate_out)
              when :in_out
                method(:animate_in_out)
              end.to_proc

      while Time.now < end_time
        break if @running == false

        elapsed = Time.now - start_time

        progress = func.call(elapsed / @duration)

        @reactive.value = (@from + ((@target - @from) * progress)).ceil.to_i
        sleep(0.001)
      end

      @reactive.value = @target if @reactive.value != @target && @running == true

      @running = false
    end
  end

  def stop
    @running = false
  end
end
