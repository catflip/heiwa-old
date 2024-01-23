class MouseEvent < Event
  attr_reader :window_id, :state, :button, :clicks, :x, :y

  set_aliases :mouse_button, :mouse_down, :mouse_up, :mouse_click, :click

  def initialize(options)
    super(options)

    @window_id = options[:window_id]
    @state = options[:state]
    @button = options[:button] || 0
    @clicks = options[:clicks] || 0
    @x = options[:x] || 0
    @y = options[:y] || 0

    @type = case @state
            when :down
              :mouse_down
            when :up
              %i[mouse_up mouse_button mouse_click click]
            end
  end

  def left?
    button == 1
  end

  def middle?
    button == 2
  end

  def right?
    button == 3
  end
end
