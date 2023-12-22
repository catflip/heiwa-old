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
    # @type [Event]
    event = case Event.format_type(sdl_event[:type])
            when :window_event
              WindowEvent
            when :mouse_move
              MouseMoveEvent
            when :mouse_down, :mouse_up, :mouse_wheel
              MouseEvent
            end

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
end
