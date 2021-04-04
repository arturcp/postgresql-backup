class PostgresqlBackup
  require_relative 'railtie' if defined?(Rails)

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
