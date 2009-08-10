require File.expand_path(File.dirname(__FILE__) + '/../../example_helper')

describe Kronos::HTTPartyExtensions do

  it "should be included in HTTParty::Response" do
    HTTParty::Response.included_modules.should include(Kronos::HTTPartyExtensions)
  end

  it "should add an ease of use method to check for invalid (422) responses" do
    HTTParty::Response.new('delegate', 'body', '422', 'message').invalid?.should == true
    HTTParty::Response.new('delegate', 'body', '200', 'message').invalid?.should == false
  end
  
end
