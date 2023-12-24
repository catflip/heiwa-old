module ReactiveAccessor
  # Creates writers and readers for reactive variables
  def reactive_accessor(*vars)
    reactive_reader(*vars)
    reactive_writer(*vars)
  end

  # Creates writers for reactive variables
  def reactive_writer(*vars)
    vars.each do |var|
      define_method(:"#{var}=") do |val|
        value = instance_variable_get(:"@#{var}")
        if value.is_a? Reactive
          value.value = val
        elsif value.is_a? Computed
          raise 'Cannot create writers for computed variables.'
        else
          instance_variable_set(:"@#{var}", val)
        end
      end
    end
  end

  # Creates readers for reactive or computed variables
  def reactive_reader(*vars)
    vars.each do |var|
      define_method(var) do
        value = instance_variable_get(:"@#{var}")
        if value.is_a? Reactive
          value.value
        elsif value.is_a? Computed
          value.read
        else
          value
        end
      end
    end
  end
end
