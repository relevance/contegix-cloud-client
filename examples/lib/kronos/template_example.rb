require File.expand_path(File.dirname(__FILE__) + '/../../example_helper')

describe Kronos::Template do
  
  it "should use the new api token if it is set after the class is loaded" do
    Kronos.api_token = 'templateapitoken'
    Kronos::Template.default_params[:api_token].should == 'templateapitoken'
  end
  
  it "should use the new base uri if it is set after the class is loaded" do
    Kronos.base_uri = 'http://template.notsolocalhost/api/v1'
    Kronos::Template.base_uri.should == 'http://template.notsolocalhost/api/v1'
  end
  
end
