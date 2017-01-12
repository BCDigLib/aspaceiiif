# -*- encoding: utf-8 -*-
# stub: rjack-jackson 1.8.11.0 java lib

Gem::Specification.new do |s|
  s.name = "rjack-jackson"
  s.version = "1.8.11.0"
  s.platform = "java"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["David Kellum"]
  s.date = "2012-11-10"
  s.email = ["dek-oss@gravitext.com"]
  s.extra_rdoc_files = ["History.rdoc", "README.rdoc"]
  s.files = ["History.rdoc", "README.rdoc"]
  s.homepage = "http://rjack.rubyforge.org/jackson"
  s.rdoc_options = ["--main", "README.rdoc"]
  s.rubygems_version = "2.4.8"
  s.summary = "A gem packaging of Jackson JSON Processor."

  s.installed_by_version = "2.4.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<minitest>, ["~> 2.2"])
      s.add_development_dependency(%q<rjack-tarpit>, ["~> 2.0"])
    else
      s.add_dependency(%q<minitest>, ["~> 2.2"])
      s.add_dependency(%q<rjack-tarpit>, ["~> 2.0"])
    end
  else
    s.add_dependency(%q<minitest>, ["~> 2.2"])
    s.add_dependency(%q<rjack-tarpit>, ["~> 2.0"])
  end
end
