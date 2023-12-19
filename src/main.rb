require 'fileutils'

require_relative '../lib/architect'

require_relative 'config'
require_relative 'window'
require_relative 'widget'

Architect.init_sdl

# Initialize Configuration
CONFIG = Config.init_config

# Find the widgets
CONFIG.widgets.each do |widget|
  widget_path = File.join(Config.config_path, widget.to_s, 'init.rb')
  next unless File.exist? widget_path

  # Simply require the widget, nothing more is needed
  load_widget(widget, widget_path)
end

# @type [Array<Thread>]
threads = {}

# @param [Widget] widget
$WIDGETS.each do |name, widget|
  threads[name] = Thread.new do
    win_opts = widget.options.filter { |k, _| %i[title x y width height type background_color].include? k }
    puts win_opts.inspect

    window = Window.new win_opts
    renderer = window.renderer

    loop do
      window.render do
        # Render the widget components
        # @param [Component] component
        widget.components.each do |component|
          component.render(renderer)
        end
      end
    end
  end
end

threads.each_value(&:join)
