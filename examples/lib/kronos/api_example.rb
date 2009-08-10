require File.expand_path(File.dirname(__FILE__) + '/../../example_helper')

class Kronos::OnlyInTest
  include Kronos::Api
end

describe Kronos::Api do
 
  describe "classes that include Kronos::Api" do

    describe "http party settings" do

      it "should set the base uri to Kronos.base_uri" do
        Kronos::OnlyInTest.base_uri.should == Kronos.base_uri
      end

      it "should place the Kronos.api_token in the default params" do
        Kronos::OnlyInTest.default_params.should include(:api_token => Kronos.api_token)
      end

    end

    describe "deriving the plural class name for use in urls" do

      it "should demodulize and tabelize the class name" do
        Kronos::OnlyInTest.name.should == 'Kronos::OnlyInTest'
        Kronos::OnlyInTest.plural_class_name_for_url.should == 'only_in_tests'
      end

    end

    describe "deriving the singular class name for use in urls" do

      it "should singularize the plural class name" do
        Kronos::OnlyInTest.singular_class_name_for_url.should == 'only_in_test'
      end

    end

    describe "all" do

      it "should perform an HTTP GET request to the 'plural_class_name_for_url'" do
        Kronos::OnlyInTest.expects(:get).with('/only_in_tests').returns([{}])
        Kronos::OnlyInTest.all
      end

      it "should initialize a class for each result of the HTTP GET" do
        Kronos::OnlyInTest.stubs(:get).returns([{}, {}, {}])
        Kronos::OnlyInTest.expects(:new).times(3)
        Kronos::OnlyInTest.all
      end

    end

    describe "find by uuid" do

      it "should perform an HTTP GET request to the 'plural_class_name_for_url/:uuid'" do
        response = HTTParty::Response.new(stub_everything, stub_everything, 200, stub_everything)
        Kronos::OnlyInTest.expects(:get).with('/only_in_tests/uuid').returns(response)
        Kronos::OnlyInTest.find_by_uuid('uuid')
      end

      it "should initialize the class with the result of the HTTP GET" do
        response = { 'only_in_test' => { 'name' => 'foo' } }
        response.stubs(:code).returns(200)
        Kronos::OnlyInTest.stubs(:get).returns(response)
        Kronos::OnlyInTest.expects(:new).with('only_in_test' => { 'name' => 'foo' })
        Kronos::OnlyInTest.find_by_uuid('uuid')
      end

      it "should return nil if the resource could not be found" do
        response = HTTParty::Response.new(stub_everything, stub_everything, 404, stub_everything)
        Kronos::OnlyInTest.stubs(:get).returns(response)
        Kronos::OnlyInTest.find_by_uuid('uuid').should == nil
      end

    end

    describe "method missing attribute proxy" do
      
      it "should use method missing to allow dot access to attributes" do
        only_in_test = Kronos::OnlyInTest.new('only_in_test' => { 'name' => 'foo' }) 
        only_in_test.respond_to?('name').should be_false
        only_in_test.name.should == 'foo'
      end

    end

  end

end
