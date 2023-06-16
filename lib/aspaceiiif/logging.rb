require 'logger'

module Logging
    class MultiDelegator
      def initialize(*targets)
        @targets = targets
      end
  
      def self.delegate(*methods)
        methods.each do |m|
          define_method(m) do |*args|
            @targets.map { |t| t.send(m, *args) }
          end
        end
        self
      end
  
      class << self
        alias to new
      end
    end
  
    def logger
      @logger ||= Logging.logger_for(self.class.name)
    end
  
    # Use a hash class-ivar to cache a unique Logger per class:
    @loggers = {}
  
    class << self
      def logger_for(classname)
        @loggers[classname] ||= configure_logger_for(classname)
      end
  
      def configure_logger_for(classname)
        time = Time.now.strftime("%Y%m%d-%H%M%S")

        file = File.open(
          "logs/aspaceiiif-#{time}.log",
          File::WRONLY | File::APPEND | File::CREAT
        )
        # Force the buffer to flush on each write
        file.sync = true
        logger = Logger.new MultiDelegator.delegate(:write, :close).to(STDOUT, file)
        #logger.progname = classname
        logger
      end
    end
  end