module Watchable
  def initialize_watchable
    @watchers = [] if !instance_variable_defined?(:@watchers) || @watchers.nil?
  end

  # Add a watcher to the current instance
  def add_watcher(watcher)
    initialize_watchable
    @watchers << watcher
  end

  # Updates the watchers with the current value
  def update_watchers(value)
    initialize_watchable
    @watchers.each { |w| w.update(value) }
  end

  # Remove a watcher from the current instance
  def remove_watcher(watcher)
    initialize_watchable
    return if @watchers.nil? || @watchers.empty?

    @watchers.delete(watcher)
  end
end
