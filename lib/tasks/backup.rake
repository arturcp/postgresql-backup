require_relative '../tools/disclaimer'
require 'tty-prompt'
require 'tty-spinner'
require 'pastel'

namespace :postgresql_backup do
  desc 'Dumps the database'
  task dump: :environment do
    title = 'POSTGRESQL BACKUP GEM'
    text = 'Dolore ipsum sunt amet laborum voluptate elit tempor minim excepteur veniam aliqua quis labore fugiat. Irure adipisicing elit et adipisicing minim veniam. Lorem nostrud ut in aliqua deserunt anim esse voluptate officia ex amet incididunt.'
    disclaimer = Tools::Disclaimer.new
    disclaimer.show(title: title, text: text)

    pastel = Pastel.new
    prompt = TTY::Prompt.new
    spinner = TTY::Spinner.new("#{pastel.yellow("[:spinner] ")}Loading ...")

    spinner.auto_spin
    sleep(2) # Perform task
    spinner.success(pastel.green.bold("success"))

    prompt.select("Choose the file to restore?", %w(file1 file2 file3))
  end
end
