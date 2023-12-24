class WindowEvent < Event
  attr_reader :window_id

  def initialize(options)
    super(options)

    @window_id = options[:window_id]
  end
end
