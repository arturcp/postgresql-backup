require_relative '../tools/disclaimer'
require_relative '../tools/terminal'
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

    Tools::Terminal.spinner("#{pastel.yellow("[:spinner] ")}Loading ...", pastel.green.bold("done.")) do
      sleep(2) # Perform task
    end

    prompt.select("Choose the file to restore?", %w(file1 file2 file3))
  end
end
