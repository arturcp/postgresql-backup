require 'pastel'

module Tools
  class Terminal
    def self.spinner(text)
      spinner = TTY::Spinner.new("#{pastel.yellow("[:spinner] ")}#{text}...")
      spinner.auto_spin
      result = yield
      spinner.success(pastel.green.bold("done."))

      result
    end
  end
end
