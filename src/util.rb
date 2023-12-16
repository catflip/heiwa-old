class Color
  attr_accessor :r, :g, :b, :a

  # Creates a new Color.
  #
  # This can be converted to an SDL color, too.
  def initialize(red, green, blue, alpha = 255)
    @r = red
    @g = green
    @b = blue
    @a = alpha
  end

  # TODO
  # Convert to an SDL color.
  # @return [Object]
  def to_sdl; end

  def to_a
    [@r, @g, @b, @a]
  end

  # Convert a hex color to RGB(A)
  # @return [Color]
  def self.from_hex(hex)
    # remove the leading '#'
    hex.gsub! '#', ''

    # @type [Array<Integer>]
    rgb_values = hex.scan(/\h{2}/).map { |c| c.to_i(16) }
    alpha = hex_color[6, 2]&.to_i 16

    rgb_values << alpha if alpha

    Color.new(*rgb_values)
  end
end
