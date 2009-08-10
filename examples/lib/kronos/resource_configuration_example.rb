require File.expand_path(File.dirname(__FILE__) + '/../../example_helper')

describe Kronos::ResourceConfiguration do
  
  it "should use the new api token if it is set after the class is loaded" do
    Kronos.api_token = 'resourceconfigapitoken'
    Kronos::ResourceConfiguration.default_params[:api_token].should == 'resourceconfigapitoken'
  end
  
  it "should use the new base uri if it is set after the class is loaded" do
    Kronos.base_uri = 'http://resourceconfig.notsolocalhost/api/v1'
    Kronos::ResourceConfiguration.base_uri.should == 'http://resourceconfig.notsolocalhost/api/v1'
  end

end
