# vim: syntax=ruby
load 'tasks/this.rb'

This.name     = "tbar"
This.author   = "Jeremy Hinegardner"
This.email    = "jeremy@copiousfreetime.org"
This.homepage = "http://github.com/copiousfreetime/#{ This.name }"

This.ruby_gemspec do |spec|
  spec.add_dependency( 'highline', '~> 1.7' )
  spec.add_dependency( 'money', '~> 6.11' )
  spec.add_dependency( 'monetize', '~> 1.0' )
  spec.add_dependency( 'sequel', '~> 5.8' )
  spec.add_dependency( 'pg', '~> 1.0' )
  spec.add_dependency( 'trollop', '~> 2.1' )

  spec.add_development_dependency( 'rake'     , '~> 12.1')
  spec.add_development_dependency( 'minitest' , '~> 5.11' )
  spec.add_development_dependency( 'rdoc'     , '~> 6.0'  )
  spec.add_development_dependency( 'simplecov', '~> 0.16' )

  spec.required_ruby_version = '2.4.0'

end

load 'tasks/default.rake'
