# -*- encoding: utf-8 -*-
# stub: saxerator 0.9.5 ruby lib

Gem::Specification.new do |s|
  s.name = "saxerator"
  s.version = "0.9.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Bradley Schaefer"]
  s.date = "2014-11-05"
  s.description = "    Saxerator is a streaming xml-to-hash parser designed for working with very large xml files by\n    giving you Enumerable access to manageable chunks of the document.\n"
  s.email = ["bradley.schaefer@gmail.com"]
  s.homepage = "https://github.com/soulcutter/saxerator"
  s.licenses = ["MIT"]
  s.rubyforge_project = "saxerator"
  s.rubygems_version = "2.4.8"
  s.summary = "A SAX-based XML-to-hash parser for parsing large files into manageable chunks"

  s.installed_by_version = "2.4.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.4.0"])
      s.add_development_dependency(%q<rspec>, ["~> 3.1"])
    else
      s.add_dependency(%q<nokogiri>, [">= 1.4.0"])
      s.add_dependency(%q<rspec>, ["~> 3.1"])
    end
  else
    s.add_dependency(%q<nokogiri>, [">= 1.4.0"])
    s.add_dependency(%q<rspec>, ["~> 3.1"])
  end
end
