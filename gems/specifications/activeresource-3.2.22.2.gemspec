# -*- encoding: utf-8 -*-
# stub: activeresource 3.2.22.2 ruby lib

Gem::Specification.new do |s|
  s.name = "activeresource"
  s.version = "3.2.22.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["David Heinemeier Hansson"]
  s.date = "2016-02-29"
  s.description = "REST on Rails. Wrap your RESTful web app with Ruby classes and work with them like Active Record models."
  s.email = "david@loudthinking.com"
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc"]
  s.homepage = "http://www.rubyonrails.org"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--main", "README.rdoc"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.rubygems_version = "2.4.8"
  s.summary = "REST modeling framework (part of Rails)."

  s.installed_by_version = "2.4.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, ["= 3.2.22.2"])
      s.add_runtime_dependency(%q<activemodel>, ["= 3.2.22.2"])
    else
      s.add_dependency(%q<activesupport>, ["= 3.2.22.2"])
      s.add_dependency(%q<activemodel>, ["= 3.2.22.2"])
    end
  else
    s.add_dependency(%q<activesupport>, ["= 3.2.22.2"])
    s.add_dependency(%q<activemodel>, ["= 3.2.22.2"])
  end
end
