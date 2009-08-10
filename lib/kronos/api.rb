module Kronos

  module Api
    
    def self.included(kls)
      kls.send(:include, HTTParty)
      kls.extend ClassMethods
    end

    module ClassMethods
      
      def self.extended(kls)
        kls.base_uri ::Kronos.base_uri
        kls.default_params :api_token => ::Kronos.api_token
        kls.format :json
        kls.send(:attr_accessor, :attributes)
      end

      def all
        get("/#{plural_class_name_for_url}").map { |json| new(json) }
      end

      def find_by_uuid(uuid)
        result = get("/#{plural_class_name_for_url}/#{uuid}")
        return nil unless result.code == 200
        return new(result)
      end
    
      def plural_class_name_for_url
        name.demodulize.tableize
      end

      def singular_class_name_for_url
        plural_class_name_for_url.singularize
      end

      private

      def perform_request(http_method, path, options) 
        result = super
        raise(AuthorizationRequired, "You must set a valid API token.") if result.code == 401
        result
      end
        
    end

    def initialize(raw_json)
      @attributes = raw_json[self.class.singular_class_name_for_url]
    end

    def reload
      self.attributes = self.class.find_by_uuid(uuid).attributes 
      self
    end

    private

    def method_missing(attr, *args)
      if @attributes.has_key?(attr.to_s)
        @attributes[attr.to_s]
      else
        super
      end
    end
    
  end

end
