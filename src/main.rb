require 'fileutils'
require 'zeitwerk'

require_relative '../lib/architect'
require_relative 'widget'

# Zeitwerk ----
loader = Zeitwerk::Loader.new
loader.push_dir(__dir__)
loader.ignore("#{__dir__}/widget.rb")
loader.collapse("#{__dir__}/*")
loader.setup
# -------------

Architect.gl_init

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
$WIDGETS.each_value do |name, widget|
  threads[name] = Thread.new do
    win_opts = widget.options.filter { |k, _| %i[title x y width height type background_color].include? k }

    max_fps = 60
    max_frametime = 1000.fdiv(max_fps)

    window = Window.new win_opts
    renderer = window.renderer

    loop do
      widget.update

      start_time = Architect.get_ticks
      window.render do
        # Render the widget components
        # @param [Component] component
        widget.components_array.each do |component|
          component.render(renderer)
        end
      end
      end_time = Architect.get_ticks

      frame_time = end_time - start_time
      sleep((max_frametime - frame_time) / 1000) if frame_time < max_frametime
    end

    window.exit
  end
end

threads.each_value(&:join)
