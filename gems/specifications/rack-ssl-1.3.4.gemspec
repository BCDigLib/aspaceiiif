# -*- encoding: utf-8 -*-
# stub: rack-ssl 1.3.4 ruby lib

Gem::Specification.new do |s|
  s.name = "rack-ssl"
  s.version = "1.3.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Joshua Peek"]
  s.date = "2014-03-23"
  s.description = "    Rack middleware to force SSL/TLS.\n"
  s.email = "josh@joshpeek.com"
  s.homepage = "https://github.com/josh/rack-ssl"
  s.rubyforge_project = "rack-ssl"
  s.rubygems_version = "2.4.8"
  s.summary = "Force SSL/TLS in your app."

  s.installed_by_version = "2.4.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 0"])
    else
      s.add_dependency(%q<rack>, [">= 0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 0"])
  end
end
