namespace :postgresql_backup do
  desc 'Dumps the database'
  task dump: :environment do
    puts 'it works'
  end
end
