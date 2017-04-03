# encoding: utf-8

require File.expand_path('lib/version')

Gem::Specification.new do |gem|
  gem.name        = 'backup'
  gem.version     = Backup::VERSION
  gem.authors     = 'Daniel Mertgen'
  gem.email       = 'dmtask@gmx.de'
  gem.homepage    = 'https://github.com/dmtask/backup'
  gem.license     = 'MIT'
  gem.summary     = 'Backuptool'
  gem.description = ''

  gem.required_ruby_version = '>= 2.4.0'

  gem.add_dependency 'ferrets_on_fire'
  gem.add_dependency 'rgpg'
end
