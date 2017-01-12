
module JRubyJars
  def self.jruby_rack_jar_path
    File.expand_path("../jruby-rack-1.1.20.jar", __FILE__)
  end
  require jruby_rack_jar_path if defined?(JRUBY_VERSION)
end
require 'jruby/rack/version' # @deprecated to be removed in 1.2
