# -*- encoding: utf-8 -*-
# stub: sinatra-contrib 1.3.2 ruby lib

Gem::Specification.new do |s|
  s.name = "sinatra-contrib"
  s.version = "1.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Konstantin Haase", "Gabriel Andretta", "Trevor Bramble", "Nicolas Sanguinetti", "Ilya Shindyapin", "Masahiro Fujiwara", "Adrian Paca\u{142}a", "Andrew Crump", "Eliot Shepard", "Eric Marden", "Gray Manley", "Matt Lyon", "lest", "undr"]
  s.date = "2012-10-22"
  s.description = "Collection of useful Sinatra extensions"
  s.email = ["konstantin.mailinglists@googlemail.com", "ohhgabriel@gmail.com", "inbox@trevorbramble.com", "contacto@nicolassanguinetti.info", "ilya@shindyapin.com", "m-fujiwara@axsh.net", "altpacala@gmail.com", "andrew.crump@ieee.org", "eshepard@slower.net", "eric.marden@gmail.com", "g.manley@tukaiz.com", "matt@flowerpowered.com", "just.lest@gmail.com", "undr@yandex.ru"]
  s.homepage = "http://github.com/sinatra/sinatra-contrib"
  s.rubygems_version = "2.4.8"
  s.summary = "Collection of useful Sinatra extensions"

  s.installed_by_version = "2.4.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sinatra>, ["~> 1.3.0"])
      s.add_runtime_dependency(%q<backports>, [">= 2.0"])
      s.add_runtime_dependency(%q<tilt>, ["~> 1.3"])
      s.add_runtime_dependency(%q<rack-test>, [">= 0"])
      s.add_runtime_dependency(%q<rack-protection>, [">= 0"])
      s.add_runtime_dependency(%q<eventmachine>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.3"])
      s.add_development_dependency(%q<haml>, [">= 0"])
      s.add_development_dependency(%q<erubis>, [">= 0"])
      s.add_development_dependency(%q<slim>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<sinatra>, ["~> 1.3.0"])
      s.add_dependency(%q<backports>, [">= 2.0"])
      s.add_dependency(%q<tilt>, ["~> 1.3"])
      s.add_dependency(%q<rack-test>, [">= 0"])
      s.add_dependency(%q<rack-protection>, [">= 0"])
      s.add_dependency(%q<eventmachine>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.3"])
      s.add_dependency(%q<haml>, [">= 0"])
      s.add_dependency(%q<erubis>, [">= 0"])
      s.add_dependency(%q<slim>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<sinatra>, ["~> 1.3.0"])
    s.add_dependency(%q<backports>, [">= 2.0"])
    s.add_dependency(%q<tilt>, ["~> 1.3"])
    s.add_dependency(%q<rack-test>, [">= 0"])
    s.add_dependency(%q<rack-protection>, [">= 0"])
    s.add_dependency(%q<eventmachine>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.3"])
    s.add_dependency(%q<haml>, [">= 0"])
    s.add_dependency(%q<erubis>, [">= 0"])
    s.add_dependency(%q<slim>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
