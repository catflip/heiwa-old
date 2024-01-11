# Timelines provide an easy way to manage multiple animations.
class Timeline
  def initialize
    # @type [Array<Animation>]
    @animations = {
      __default: []
    }
  end

  # Add an animation to the list of animations.
  # @param [Animation] animation The animation you'd like to add.
  # @param [Symbol] label The label for your animation.
  #   You can use this label to refer to your animation(s).
  # @param [Boolean] wait Determines if we should wait for the previous
  #   animation in the timeline to finish.
  def add(animation, label: nil, wait: false)
    raise 'Only an `Animation` can be added to a timeline!' unless animation.is_a?(Animation)

    @animations[label] ||= [] unless label.nil?
    @animations[label || :__default] << {
      anim: animation,
      wait:
    }

    self
  end

  # Starts the animation timeline.
  # @param [Symbol] label Restricts the animation to a certain label.
  #   Use `:all` to start animations inside of all labels.
  def start(label = nil)
    animations = collect_by_label(label)
    animations.each_with_index do |anim, index|
      animation = anim[:anim]
      if anim[:wait] == true && index > 0
        animations[index - 1].on_complete do
          animation.start
        end
      else
        animation.start
      end
    end

    self
  end

  def stop(label = :all)
    collect_by_label(label).map { |a| a[:anim] }.each(&:stop)

    self
  end

  private

  # Collects animations based on a label.
  # @return [Array<Animation>]
  def collect_by_label(label)
    if label.nil?
      @animations[:__default]
    elsif label == :all
      @animations.values.flatten
    else
      @animations[label] || []
    end
  end
end
