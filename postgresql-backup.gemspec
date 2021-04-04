Gem::Specification.new do |s|
  s.name        = 'postgresql-backup'
  s.version     = '0.0.1'
  s.summary     = "Automate PostgreSQL's backup and restore"
  s.description = "This gem automates PostgreSQL's backup and restore in your Rails project. It will inject two rake tasks that you can use to manage your data, either by using the local system or AWS S3 storage."
  s.authors     = ["Artur Caliendo Prado"]
  s.email       = 'artur.prado@gmail.com'
  s.files       = ["lib/postgresql_backup.rb"]
  s.homepage    =
    'https://rubygems.org/gems/postgresql-backup'
  s.license       = 'MIT'

  s.add_dependency 'tty-prompt'
  s.add_dependency 'pastel'
  s.add_dependency 'tty-spinner'
end
