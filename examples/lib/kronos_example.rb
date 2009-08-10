require File.expand_path(File.dirname(__FILE__) + '/../example_helper')

describe Kronos do
  
  it "should allow the end user to read and set an API token" do
    Kronos.api_token.should_not == 'YOUR_API_TOKEN'
    Kronos.api_token = 'YOUR_API_TOKEN'
    Kronos.api_token.should == 'YOUR_API_TOKEN'
  end
  
  it "should update the default params for all dependent classes when the api token is set" do
    Kronos.expects(:update_api_token).with('YOUR_API_TOKEN')
    Kronos.api_token = 'YOUR_API_TOKEN'
  end

  describe "the base URI" do

    it "should allow the end user to read and set the base URI" do
      Kronos.base_uri = 'http://my.contegix.instance/api/v1'
      Kronos.base_uri.should == 'http://my.contegix.instance/api/v1'
    end

    it "should use a default URI when the base URI is set to nil" do
      Kronos.base_uri = nil
      Kronos.base_uri.should == 'http://localhost:3000/api/v1'
    end

    it "should automatically append the 'api/v1' suffix to the URI when it is not specified" do
      Kronos.base_uri = 'http://my.contegix.instance/'
      Kronos.base_uri.should == 'http://my.contegix.instance/api/v1'
    end

    it "should automatically append the '/api/v1' suffix to the URI when it is not specified" do
      Kronos.base_uri = 'http://my.contegix.instance'
      Kronos.base_uri.should == 'http://my.contegix.instance/api/v1'
    end

    it "should NOT append the 'api/v1' suffix to the URI when it IS specified" do
      Kronos.base_uri = 'http://my.contegix.instance/api/v1'
      Kronos.base_uri.should == 'http://my.contegix.instance/api/v1'
    end

    it "should update the base URI for all dependent classes when Kronos.base_uri is set" do
      Kronos.expects(:update_base_uri).with('http://production.example.com/api/v1/')
      Kronos.base_uri = 'http://production.example.com/api/v1/'
    end

    it "should automatically include the API suffix when updating the base_uri for dependent classes" do
      Kronos.expects(:update_base_uri).with('http://production.example.com/api/v1')
      Kronos.base_uri = 'http://production.example.com'
    end

  end
  
  it "should allow the end user to read and set basic auth info" do
    Kronos::Api.included_in_classes.each do |kls|
      kls.expects(:basic_auth).with('some username', 'some password')
    end
    Kronos.basic_auth("some username", "some password")
  end
  
  describe "#valid_configuration?" do
    
    it "should return false if the API Token is blank" do
      Kronos.api_token = nil
      Kronos.valid_configuration?.should == false
      
      Kronos.api_token = ""
      Kronos.valid_configuration?.should == false
    end
    
    it "should return false if the base URI is blank" do
      Kronos.base_uri = nil
      Kronos.valid_configuration?.should == false
      
      Kronos.base_uri = ""
      Kronos.valid_configuration?.should == false
    end
    
    it "should return true if the API token is not blank and the base URI is not blank" do
      Kronos.api_token = "some token"
      Kronos.base_uri = "some uri"
      Kronos.valid_configuration?.should == true
    end
    
  end
  
end
