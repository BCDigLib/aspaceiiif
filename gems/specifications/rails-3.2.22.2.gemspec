# -*- encoding: utf-8 -*-
# stub: rails 3.2.22.2 ruby lib

Gem::Specification.new do |s|
  s.name = "rails"
  s.version = "3.2.22.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["David Heinemeier Hansson"]
  s.date = "2016-02-29"
  s.description = "Ruby on Rails is a full-stack web framework optimized for programmer happiness and sustainable productivity. It encourages beautiful code by favoring convention over configuration."
  s.email = "david@loudthinking.com"
  s.homepage = "http://www.rubyonrails.org"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.rubygems_version = "2.4.8"
  s.summary = "Full-stack web application framework."

  s.installed_by_version = "2.4.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, ["= 3.2.22.2"])
      s.add_runtime_dependency(%q<actionpack>, ["= 3.2.22.2"])
      s.add_runtime_dependency(%q<activerecord>, ["= 3.2.22.2"])
      s.add_runtime_dependency(%q<activeresource>, ["= 3.2.22.2"])
      s.add_runtime_dependency(%q<actionmailer>, ["= 3.2.22.2"])
      s.add_runtime_dependency(%q<railties>, ["= 3.2.22.2"])
      s.add_runtime_dependency(%q<bundler>, ["~> 1.0"])
    else
      s.add_dependency(%q<activesupport>, ["= 3.2.22.2"])
      s.add_dependency(%q<actionpack>, ["= 3.2.22.2"])
      s.add_dependency(%q<activerecord>, ["= 3.2.22.2"])
      s.add_dependency(%q<activeresource>, ["= 3.2.22.2"])
      s.add_dependency(%q<actionmailer>, ["= 3.2.22.2"])
      s.add_dependency(%q<railties>, ["= 3.2.22.2"])
      s.add_dependency(%q<bundler>, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<activesupport>, ["= 3.2.22.2"])
    s.add_dependency(%q<actionpack>, ["= 3.2.22.2"])
    s.add_dependency(%q<activerecord>, ["= 3.2.22.2"])
    s.add_dependency(%q<activeresource>, ["= 3.2.22.2"])
    s.add_dependency(%q<actionmailer>, ["= 3.2.22.2"])
    s.add_dependency(%q<railties>, ["= 3.2.22.2"])
    s.add_dependency(%q<bundler>, ["~> 1.0"])
  end
end
