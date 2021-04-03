class PostgresqlBackup
  require_relative 'railtie' if defined?(Rails)

  def self.hello
    puts "Hello world!"
  end
end
