module Mysql2xxxx
  class Properties
    attr_reader :options
    def initialize(options = {})
      @options = options.dup
      @options.stringify_keys!
    end
    
    def database_config
      {
        :username => user,
        :password => password,
        :host => host,
        :port => port,
        :database => database
      }
    end

    def user
      options['user'] || active_record_config.try(:[], :username)
    end
    
    def password
      options['password'] || active_record_config.try(:[], :password)
    end
    
    def host
      options['host'] || active_record_config.try(:[], :host)
    end
    
    def port
      options['port'] || active_record_config.try(:[], :port)
    end
    
    def database
      options['database'] || active_record_connection.try(:current_database)
    end
    
    def execute
      options['execute']
    end
        
    private
    
    def active_record_connection
      if defined?(::ActiveRecord)
        ::ActiveRecord::Base.connection
      end
    rescue
      # oh well
    end
    
    def active_record_config
      if active_record_connection
        active_record_connection.instance_variable_get :@config
      end
    end
  end
end
