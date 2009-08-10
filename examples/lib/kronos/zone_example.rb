require File.expand_path(File.dirname(__FILE__) + '/../../example_helper')

describe Kronos::Zone do
  
  it "should use the new api token if it is set after the class is loaded" do
    Kronos.api_token = 'zoneapitoken'
    Kronos::Zone.default_params[:api_token].should == 'zoneapitoken'
  end
  
  it "should use the new base uri if it is set after the class is loaded" do
    Kronos.base_uri = 'http://zone.notsolocalhost/api/v1'
    Kronos::Zone.base_uri.should == 'http://zone.notsolocalhost/api/v1'
  end
  
end
