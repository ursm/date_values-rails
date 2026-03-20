# frozen_string_literal: true

require_relative 'lib/date_values/rails/version'

Gem::Specification.new do |spec|
  spec.name    = 'date_values-rails'
  spec.version = DateValues::Rails::VERSION
  spec.authors = ['Keita Urashima']
  spec.email   = ['ursm@ursm.jp']

  spec.summary  = 'Rails integration for date_values'
  spec.homepage = 'https://github.com/ursm/date_values-rails'
  spec.license  = 'MIT'
  spec.required_ruby_version = '>= 3.3.0'

  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/ursm/date_values-rails'
  spec.metadata['changelog_uri']   = 'https://github.com/ursm/date_values-rails/blob/main/CHANGELOG.md'

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore test/ .github/])
    end
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'date_values', '>= 0.2.0'
  spec.add_dependency 'activemodel', '>= 7.2'
end
