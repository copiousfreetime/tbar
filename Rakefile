# vim: syntax=ruby
load 'tasks/this.rb'

This.name     = "tbar"
This.author   = "Jeremy Hinegardner"
This.email    = "jeremy@copiousfreetime.org"
This.homepage = "http://github.com/copiousfreetime/#{ This.name }"

This.ruby_gemspec do |spec|
  spec.add_dependency( 'money', '~> 6.0' )

  spec.add_development_dependency( 'rake'     , '~> 10.1')
  spec.add_development_dependency( 'minitest' , '~> 5.3' )
  spec.add_development_dependency( 'rdoc'     , '~> 4.1'  )
  spec.add_development_dependency( 'simplecov', '~> 0.8' )

  spec.required_ruby_version = '>= 1.9.2'

end

load 'tasks/default.rake'
