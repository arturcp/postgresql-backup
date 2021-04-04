module Tools
  class Terminal
    def self.spinner(text, success_message)
      spinner = TTY::Spinner.new(text)
      spinner.auto_spin
      yield
      spinner.success(success_message)
    end
  end
end
