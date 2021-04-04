require 'pastel'

module Tools
  class Terminal
    def self.spinner(text)
      spinner = TTY::Spinner.new("#{pastel.yellow("[:spinner] ")}#{text}...")
      spinner.auto_spin
      yield
      spinner.success(pastel.green.bold("done."))
    end
  end
end
