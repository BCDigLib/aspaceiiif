# -*- encoding: utf-8 -*-
# stub: sinatra-reloader 1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "sinatra-reloader"
  s.version = "1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Konstantin Haase"]
  s.date = "2011-10-28"
  s.description = "Dummy gem, sinatra-reloader is now part of sinatra-contrib: http://www.sinatrarb.com/contrib/"
  s.email = "konstantin.mailinglists@googlemail.com"
  s.homepage = "http://github.com/sinatra/sinatra-contrib"
  s.rubygems_version = "2.4.8"
  s.summary = "Dummy gem, sinatra-reloader is now part of sinatra-contrib."

  s.installed_by_version = "2.4.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sinatra-contrib>, [">= 0"])
    else
      s.add_dependency(%q<sinatra-contrib>, [">= 0"])
    end
  else
    s.add_dependency(%q<sinatra-contrib>, [">= 0"])
  end
end
