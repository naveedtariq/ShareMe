# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{authlogic-connect}
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Lance Pollard}]
  s.date = %q{2010-07-14}
  s.description = %q{Oauth and OpenID made dead simple}
  s.email = %q{lancejpollard@gmail.com}
  s.homepage = %q{http://github.com/viatropos/authlogic-connect}
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{authlogic-connect}
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Authlogic Connect: Oauth and OpenID made dead simple}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 2.1.2"])
      s.add_runtime_dependency(%q<activerecord>, [">= 2.1.2"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<ruby-openid>, [">= 0"])
      s.add_runtime_dependency(%q<rack-openid>, [">= 0.2.1"])
      s.add_runtime_dependency(%q<oauth>, [">= 0"])
      s.add_runtime_dependency(%q<oauth2>, [">= 0"])
      s.add_runtime_dependency(%q<authlogic>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, [">= 2.1.2"])
      s.add_dependency(%q<activerecord>, [">= 2.1.2"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<ruby-openid>, [">= 0"])
      s.add_dependency(%q<rack-openid>, [">= 0.2.1"])
      s.add_dependency(%q<oauth>, [">= 0"])
      s.add_dependency(%q<oauth2>, [">= 0"])
      s.add_dependency(%q<authlogic>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 2.1.2"])
    s.add_dependency(%q<activerecord>, [">= 2.1.2"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<ruby-openid>, [">= 0"])
    s.add_dependency(%q<rack-openid>, [">= 0.2.1"])
    s.add_dependency(%q<oauth>, [">= 0"])
    s.add_dependency(%q<oauth2>, [">= 0"])
    s.add_dependency(%q<authlogic>, [">= 0"])
  end
end
