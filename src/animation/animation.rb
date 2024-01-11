class Animation
  # Animate a numeric `Reactive` variable to another one.
  #
  # @param [Reactive] reactive The `Reactive` variable to animate.
  # @param [Any] target The value to animate to.
  # @param [Numeric] duration The duration of the animation in seconds.
  # @param [Easing] easing The easing function.
  def initialize(reactive, target, duration, easing, mode)
    unless reactive.is_a?(Reactive) || reactive.is_a?(Component)
      raise 'Animation target must be a Component or a Reactive value!'
    end

    @reactive = reactive
    @target = target
    @duration = duration
    @easing = easing

    mode = :out unless %i[in out in_out].include? mode
    @mode = mode

    @running = false

    @on_complete = []
  end

  def start
    return if @running == true

    @running = true

    start_time = Architect.get_ticks
    end_time = start_time + @duration

    easing_func = @easing.method(:"animate_#{@mode}")
    animate_func = case @reactive
                   when Reactive
                     :animate_reactive
                   when Component
                     :animate_component
                   end
    animate_func = method(animate_func)

    animate_func.call(easing_func, start_time, end_time)

    self
  end

  def stop
    @running = false
  end

  ##
  ## Events
  ##

  # Runs your block on the Animation's completion.
  # @param [Proc] block
  def on_complete(&block)
    @on_complete << block
    self
  end

  private

  # Animates a `Reactive` variable.
  #
  # @param [Proc] easing The Easing function.
  # @param [Time] start_time Start time.
  # @param [Time] end_time End time.
  def animate_reactive(easing, start_time, end_time)
    animate_value(@reactive, @target, easing, start_time, end_time)
  end

  # Animates a `Component`.
  #
  # @param [Proc] easing The Easing function.
  # @param [Time] start_time Start time.
  # @param [Time] end_time End time.
  def animate_component(easing, start_time, end_time)
    # We are suspecting that @target is a Hash.
    # We can't do anything if it isn't.
    raise 'Animation target value must be a `Hash` when animating components!' unless @target.is_a?(Hash)

    # @type [Component]
    comp = @reactive

    @target.each do |k, v|
      var = comp.get(k)
      animate_value(var, v, easing, start_time, end_time)
    end
  end

  # Animates a literal value to the target via Easing.
  #
  # @param [Reactive] reactive The Reactive target.
  # @param [Any] target The target value.
  # @param [Proc] easing The Easing function.
  # @param [Integer] start_time Start time.
  # @param [Integer] end_time End time.
  def animate_value(reactive, target, easing, start_time, end_time)
    Thread.new do
      from = reactive.value

      # We can only animate a limited variety of values.
      if target.is_a?(Numeric)
        while Architect.get_ticks < end_time
          break if @running == false

          elapsed = Architect.get_ticks - start_time

          progress = easing.call(elapsed.fdiv @duration)
          reactive.value = (from + ((target - from) * progress)).ceil.to_i

          sleep(0.001)
        end
      else
        sleep(@duration / 1000)
      end

      reactive.value = target if reactive.value != target && @running == true
      @running = false
      @on_complete.each(&:call)
    end
  end
end
