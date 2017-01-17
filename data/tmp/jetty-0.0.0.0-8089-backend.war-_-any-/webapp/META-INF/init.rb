WARBLER_CONFIG = {"public.root"=>"/", "rack.env"=>"production", "jruby.compat.version"=>"1.9", "jruby.min.runtimes"=>"1", "jruby.max.runtimes"=>"1"}

if $servlet_context.nil?
  ENV['GEM_HOME'] = File.expand_path(File.join('..', '..', '/WEB-INF/gems'), __FILE__)

else
  ENV['GEM_HOME'] = $servlet_context.getRealPath('/WEB-INF/gems')

end
ENV['RACK_ENV'] ||= 'production'

$LOAD_PATH.unshift $servlet_context.getRealPath('/WEB-INF') if $servlet_context
