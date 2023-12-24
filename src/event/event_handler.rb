require 'securerandom'

module EventHandler
  # Registers a listener on an SDL_Event.
  # @return [String] The event's ID
  def add_event(event, &block)
    raise "Can't add event if `@widget` is `nil`!" if @widget.nil?
    raise "Can't add event without a block!" unless block_given?

    id = SecureRandom.hex

    widget.register_event id, event, block

    id
  end

  # Removes an event listener.
  # @param [String] id The event's id
  def remove_event(id)
    widget.events.delete_if { |ev| ev[:id] == id }
  end
end
