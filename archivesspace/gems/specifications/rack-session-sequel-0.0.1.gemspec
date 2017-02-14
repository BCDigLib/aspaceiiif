# -*- encoding: utf-8 -*-
# stub: rack-session-sequel 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "rack-session-sequel"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Masato Igarashi"]
  s.date = "2012-01-29"
  s.description = "Rack session store for Sequel"
  s.email = ["m@igrs.jp"]
  s.homepage = "http://github.com/migrs/rack-session-sequel"
  s.rubygems_version = "2.4.8"
  s.summary = "Rack session store for Sequel"

  s.installed_by_version = "2.4.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bacon>, [">= 0"])
      s.add_runtime_dependency(%q<rack>, [">= 0"])
      s.add_runtime_dependency(%q<sequel>, [">= 0"])
    else
      s.add_dependency(%q<bacon>, [">= 0"])
      s.add_dependency(%q<rack>, [">= 0"])
      s.add_dependency(%q<sequel>, [">= 0"])
    end
  else
    s.add_dependency(%q<bacon>, [">= 0"])
    s.add_dependency(%q<rack>, [">= 0"])
    s.add_dependency(%q<sequel>, [">= 0"])
  end
end
