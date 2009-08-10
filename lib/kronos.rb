require 'rubygems'
require 'httparty'
require 'activesupport'

module Kronos
  
  mattr_accessor :api_token
  mattr_writer :base_uri
  
  def self.base_uri
    @@base_uri ||= base_uri_with_api_suffix('http://localhost:3000')
  end
  
  def self.base_uri=(new_base_uri)
    @@base_uri = base_uri_with_api_suffix(new_base_uri)
    update_base_uri(@@base_uri)
  end
  
  def self.api_token=(new_api_token)
    @@api_token = new_api_token
    update_api_token(new_api_token)
  end
  
  def self.basic_auth(username, password)
    Kronos::Api.included_in_classes.each do |kls|
      kls.basic_auth username, password
    end
  end
  
  def self.update_base_uri(new_uri)
    Kronos::Api.included_in_classes.each do |kls|
      kls.base_uri new_uri
    end
  end
  
  def self.update_api_token(new_api_token);
    Kronos::Api.included_in_classes.each do |kls|
      kls.default_params[:api_token] = new_api_token
    end
  end
  
  def self.valid_configuration?
    !api_token.blank? && !base_uri.blank?
  end

  class InvalidRequest < StandardError; end
  class AuthorizationRequired < StandardError; end

  protected
  
  def self.base_uri_with_api_suffix(uri)
    return unless uri
    return uri if uri.match %r{api/v1/?$}
    uri_with_trailing_slash = uri.match(%r{/$}) ? uri : (uri + '/')
    uri_with_trailing_slash + 'api/v1'
  end
  
end

require 'kronos/httparty_extensions'
require 'kronos/api'
require 'kronos/resource_configuration'
require 'kronos/template'
require 'kronos/virtual_machine'
require 'kronos/zone'
require 'kronos/sample'