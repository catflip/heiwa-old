class Animator
  def initialize(options = {})
    @options = parse_options(options)
  end

  # Animate a `Reactive` target to `values`.
  def to(reactive, target, options = {})
    options = @options.merge(parse_options(options, omit: true))

    animation = Animation.new(
      reactive, target,
      options[:duration],
      options[:ease],
      options[:mode]
    )

    animation.start unless options[:omit_start] == true

    animation
  end

  private

  # Parse animation options into a usable format
  def parse_options(options, omit: false)
    {
      omit_start: options[:omit_start] || (omit ? nil : true),
      ease: parse_easing(
        options[:ease] || (omit ? nil : :linear),
        options[:ease_options]
      ),
      mode: options[:mode] || (omit ? nil : :out),
      duration: options[:duration] || (omit ? nil : 1000)
    }.compact
  end

  # Get the correct easing from a symbol
  #
  # @param [Symbol] easing The symbol to resolve.
  # @param [Hash] easing_options Options for specific types of easings.
  def parse_easing(easing, easing_options)
    case easing
    when :linear
      LinearEasing
    when :cubic
      CubicEasing
    when :elastic
      ElasticEasing
    end&.new(easing_options)
  end
end
