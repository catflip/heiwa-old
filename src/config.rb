module Config
  # Global configuration variable
  # @type [Configuration]
  @config = nil

  DEFAULT_CONFIG_PATH = File.join(Dir.home, '.config', 'heiwa')
  DEFAULT_CONFIG_FILE_PATH = File.join(DEFAULT_CONFIG_PATH, 'config.rb')

  # A simple class for storing the configuration.
  class FileConfig
    attr_accessor :widgets, :reload

    def initialize
      @widgets = []
      @reload = false
    end
  end

  # Helper method that exposes the `Configuration` class to config files.
  def self.make_config
    @config = FileConfig.new
    yield @config
  end

  # Initializes the config and returns it
  # @return [Configuration]
  def self.init_config
    # Create the directory if it doesn't exist
    FileUtils.mkdir_p(DEFAULT_CONFIG_PATH) unless DEFAULT_CONFIG_PATH

    # Read the configuration object. This should return a valid hash.
    unless File.exist? DEFAULT_CONFIG_FILE_PATH
      raise "ERR: Configuration directory `#{DEFAULT_CONFIG_FILE_PATH}` does not exist. Please make sure it does."
    end

    # Read the configuration
    load(DEFAULT_CONFIG_FILE_PATH)

    @config
  end

  def self.config_path
    DEFAULT_CONFIG_PATH
  end

  def self.config_file_path
    DEFAULT_CONFIG_FILE_PATH
  end
end
