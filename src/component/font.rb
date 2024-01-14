$FONT_CACHE = {}

class Font
  # Creates a new TTF font
  #
  # @param [String] font The name or path of the font
  def initialize(font)
    unless File.exist?(font)
      begin
        font = `fc-match "#{font}" -f "%{file}"`
      rescue Errno::ENOENT
        raise "Failed to execute `fc-match`. Maybe it's not installed on your system?"
      end
    end

    @path = font
    $FONT_CACHE[@path] = {}
  end

  # Opens the font with a given size
  #
  # @param [Integer] size The size of the font
  # @return [Object] The font
  def open(size)
    $FONT_CACHE[@path][size] ||= Architect.open_font(@path, size)
  end

  # Closes the font. Specify a size if you only want to close
  # a singular size.
  #
  # @param [Integer, Array<Integer>] size The size of the font
  def close(size = nil)
    if size.nil?
      $FONT_CACHE[@path].each_value { |f| Architect.close_font(f) }
    elsif size.is_a? Numeric
      Architect.close_font($FONT_CACHE[@path][size])
    elsif size.is_a? Array
      size.each { |s| Architect.close_font($FONT_CACHE[@path][s]) }
    end
  end
end
