class Event
  attr_reader :type

  # @param [Hash] options The event hash
  # @option options [Integer] :type The event's type (SDL_Events)
  def initialize(options)
    @type = Event.format_type(options[:type]) || :unknown
  end

  # Returns the specific event type from a custom schema.
  # @param [Hash] sdl_event The event hash
  def self.from_hash(sdl_event)
    # Automatically get all modules that end with 'Event'
    # and extend `self` (`Event`).
    valid_events = Module.constants
                         .filter { |c| c.end_with? 'Event' }
                         .map { |m| Module.const_get(m) }
                         .filter { |m| m < self }

    type = format_type(sdl_event[:type])

    # @type [Event]
    event = valid_events.find { |ev| ev&.aliases&.include? type }
    return nil if event.nil?

    event.new sdl_event
  end

  # Format an SDL_Events integer into a readable symbol.
  # @return [Symbol]
  def self.format_type(type)
    case type
    when 512
      :window_event
    when 1024
      :mouse_move
    when 1025
      :mouse_down
    when 1026
      :mouse_up
    when 1027
      :mouse_wheel
    else
      :unknown
    end
  end

  def self.set_aliases(*aliases)
    instance_variable_set :@aliases, aliases
  end

  def self.aliases
    return [] unless instance_variable_defined? :@aliases

    instance_variable_get :@aliases
  end
end
