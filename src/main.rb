require_relative '../lib/architect'

Architect.init_sdl

win = Architect.create_window(title: 'Hello, world!', width: 512, height: 512)
rend = Architect.create_renderer(win)

loop do
  Architect.render_clear rend
  Architect.render_present rend
  sleep 16
end
