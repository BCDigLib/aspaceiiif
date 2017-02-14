# -*- encoding: utf-8 -*-
# stub: rufus-lru 1.0.5 ruby lib

Gem::Specification.new do |s|
  s.name = "rufus-lru"
  s.version = "1.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["John Mettraux"]
  s.date = "2012-02-27"
  s.description = "LruHash class, a Hash with a max size, controlled by a LRU mechanism"
  s.email = ["jmettraux@gmail.com"]
  s.homepage = "http://github.com/jmettraux/rufus-lru"
  s.rubyforge_project = "rufus"
  s.rubygems_version = "2.4.8"
  s.summary = "A Hash with a max size, controlled by a LRU mechanism"

  s.installed_by_version = "2.4.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 2.7.0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 2.7.0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 2.7.0"])
  end
end
