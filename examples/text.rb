make_widget(
  title: 'Text',
  x: 0, y: 0,
  width: :max,
  height: 80,
  type: :dock
)

font = Font.new('/usr/share/fonts/jetbrains-mono/JetBrainsMono-Regular.ttf')

root do |_, children|
  children << make(:text, x: 10, y: 10, content: 'Hello, World!', font:)
end
