# -*- encoding: utf-8 -*-
# stub: jdbc-derby 10.6.2.1 java lib

Gem::Specification.new do |s|
  s.name = "jdbc-derby"
  s.version = "10.6.2.1"
  s.platform = "java"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Nick Sieger, Ola Bini and JRuby contributors"]
  s.date = "2010-10-12"
  s.description = "Install this gem and require 'derby' within JRuby to load the driver."
  s.email = "nick@nicksieger.com, ola.bini@gmail.com"
  s.extra_rdoc_files = ["Manifest.txt", "README.txt", "LICENSE.txt"]
  s.files = ["LICENSE.txt", "Manifest.txt", "README.txt"]
  s.homepage = "http://jruby-extras.rubyforge.org/ActiveRecord-JDBC"
  s.rdoc_options = ["--main", "README.txt"]
  s.rubyforge_project = "jruby-extras"
  s.rubygems_version = "2.4.8"
  s.summary = "Derby/JavaDB JDBC driver for Java and Derby/ActiveRecord-JDBC."

  s.installed_by_version = "2.4.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rubyforge>, [">= 2.0.4"])
    else
      s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
    end
  else
    s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
  end
end
