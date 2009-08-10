require File.expand_path(File.dirname(__FILE__) + '/../../example_helper')

describe Kronos::VirtualMachine do
  
  it "should use the new api token if it is set after the class is loaded" do
    Kronos.api_token = 'vmapitoken'
    Kronos::VirtualMachine.default_params[:api_token].should == 'vmapitoken'
  end
  
  it "should use the new base uri if it is set after the class is loaded" do
    Kronos.base_uri = 'http://vm.notsolocalhost/api/v1'
    Kronos::VirtualMachine.base_uri.should == 'http://vm.notsolocalhost/api/v1'
  end

  it "should have an accessor to retrieve its resource configuration" do
    vm = Kronos::VirtualMachine.new('virtual_machine' => { 'resource_configuration_uuid' => '112233445566778899' })
    Kronos::ResourceConfiguration.expects(:find_by_uuid).with('112233445566778899').returns(:resource_config)
    vm.resource_configuration.should == :resource_config
  end

  it "should have an accessor to retrieve its template" do
    vm = Kronos::VirtualMachine.new('virtual_machine' => { 'template_uuid' => '112233445566778899' })
    Kronos::Template.expects(:find_by_uuid).with('112233445566778899').returns(:template)
    vm.template.should == :template
  end

  describe "resizing a virtual machine" do

    it "should use a HTTP PUT request" do
      vm = Kronos::VirtualMachine.new('virtual_machine' => { 'uuid' => '112233445566778899' })
      Kronos::VirtualMachine.expects(:put)
      vm.resize!(stub_everything('new resource config'))
    end

    it "should include the requested resource configuration uuid as 'resource_configuration_id' in the query data" do
      vm = Kronos::VirtualMachine.new('virtual_machine' => { 'uuid' => '112233445566778899' })
      Kronos::VirtualMachine.expects(:put).with(anything, 
                                          :query => { :virtual_machine => { :resource_configuration_id => 'newrcuuid' } })
      vm.resize!(stub_everything('new resource config', :uuid => 'newrcuuid'))
    end

  end

  describe "creating a new virtual machine" do
    
    it "should use a HTTP POST request" do
      Kronos::VirtualMachine.expects(:post).returns(stub_everything('response', :invalid? => false))
      Kronos::VirtualMachine.create!('resource_configuration_id' => '112233445566778899')
    end

    it "should raise an ArgumentError if the options hash is nil or empty" do
      lambda { Kronos::VirtualMachine.create!(nil) }.should raise_error(ArgumentError)
      lambda { Kronos::VirtualMachine.create!({}) }.should raise_error(ArgumentError)
    end

    it "should raise an InvalidRequest with the errors returned if the request fails" do
      failed_response = stub('response', :map => ["resource configuration id can't be blank"], :invalid? => true)
      Kronos::VirtualMachine.stubs(:post).returns(failed_response)

      lambda { 
        Kronos::VirtualMachine.create!('template_id' => '1234') 
      }.should raise_error(Kronos::InvalidRequest, "resource configuration id can't be blank")
    end

    it "should return the VirtualMachine if the request succeeds" do
      Kronos::VirtualMachine.stubs(:post).returns(valid_response = stub_everything('response', :invalid? => false, :inspect => 'foo'))
      Kronos::VirtualMachine.create!('resource_configuration_id' => '112233445566778899').should be_instance_of(Kronos::VirtualMachine)
    end

  end
  
end
