require 'pastel'
require 'tty-spinner'

module Tools
  class Terminal
    def self.spinner(text)
      pastel = Pastel.new

      spinner = TTY::Spinner.new("#{pastel.yellow("[:spinner] ")}#{text}...")
      spinner.auto_spin
      result = yield
      spinner.success(pastel.green.bold("done."))

      result
    end
  end
end
