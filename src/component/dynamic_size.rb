module DynamicSize
  def dynamic_width
    if !instance_variable_defined?(:@width) || @width.nil?
      raise 'Cannot use `dynamic_width` without `@width`. Does your component support `@width`?'
    end

    case width
    when Numeric
      width
    when Symbol
      calculate_symbol width, Screen.width(0), parent&.dynamic_width
    when String
      calculate_string width, (parent&.dynamic_width || Screen.width(0))
    when Proc
      calculate_proc width, (parent&.dynamic_width || Screen.width(0))
    end
  end

  def dynamic_height
    if !instance_variable_defined?(:@height) || @height.nil?
      raise 'Cannot use `dynamic_height` without `@height`. Does your component support `@height`?'
    end

    case height
    when Numeric
      height
    when Symbol
      calculate_symbol height, Screen.height(0), parent&.dynamic_height
    when String
      calculate_string height, (parent&.dynamic_height || Screen.height(0))
    when Proc
      calculate_proc height, (parent&.dynamic_height || Screen.height(0))
    end
  end

  private

  # @param [Symbol] sym
  def calculate_symbol(sym, max_size, parent_size)
    # TODO: Handle either `:min` or `:max`
    raise "Invalid size symbol: #{sym}" unless sym == :max

    if parent.nil?
      # Top level element
      max_size
    else
      # Parent should have a `dynamic_height`
      parent_size
    end
  end

  # @param [String] str
  def calculate_string(str, parent_size)
    # Handle percentage or number conversion
    if str.end_with? '%'
      perc = str.gsub('%', '').to_f
      ((parent_size.fdiv 100) * perc).floor
    else
      str.to_i
    end
  end

  # @param [Proc] proc
  def calculate_proc(proc, parent_size)
    proc.call parent_size
  end
end
