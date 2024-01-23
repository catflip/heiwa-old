class Event
  attr_reader :type

  # @param [Hash] options The event hash
  # @option options [Integer] :type The event's type (SDL_Events)
  def initialize(options)
    @type = options[:type] || :unknown
  end

  def self.process(obj)
    return if obj[:type].nil? || obj[:window_id].nil?

    # @type [Widget]
    widget = $WIDGETS.values.flatten
                     .filter { _1.is_a?(Widget) }
                     .find { |w| w.window.window_id == obj[:window_id] }
    return if widget.nil?

    widget.handle_event(obj)
  end

  # Returns the specific event type from a custom schema.
  # @param [Hash] gl_event The event hash
  def self.from_hash(gl_event)
    # Automatically get all modules that end with 'Event'
    # and extend `self` (`Event`).
    valid_events = Module.constants
                         .filter { |c| c.end_with? 'Event' }
                         .map { |m| Module.const_get(m) }
                         .filter { |m| m < self }

    # @type [Event]
    event = valid_events.find { |ev| ev&.aliases&.include?(gl_event[:type]) }
    return nil if event.nil?

    event.new gl_event
  end

  def self.set_aliases(*aliases)
    instance_variable_set :@aliases, aliases
  end

  def self.aliases
    return [] unless instance_variable_defined? :@aliases

    instance_variable_get :@aliases
  end
end
