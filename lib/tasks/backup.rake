require_relative '../tools/disclaimer'

namespace :postgresql_backup do
  desc 'Dumps the database'
  task dump: :environment do
    title = 'POSTGRESQL BACKUP GEM'
    text = 'Dolore ipsum sunt amet laborum voluptate elit tempor minim excepteur veniam aliqua quis labore fugiat. Irure adipisicing elit et adipisicing minim veniam. Lorem nostrud ut in aliqua deserunt anim esse voluptate officia ex amet incididunt.'
    disclaimer = Tools::Disclaimer.new
    disclaimer.show(title: title, text: text)
  end
end
