# Contegix Cloud API: client reference implentation

See http://www.contegix.com/solutions/cloud-hosting.php for more information on the Contegix Cloud.

## Initial Setup 

### Requirements

* gem install httparty

### Step 1

Login into the Contegix Cloud, go to your account page, and get your API key.

### Step 2

Run the following from the Contegix Cloud client source directory:

    sh> ./script/console

### Step 3

Set your API key, Contegix cloud base URL, and optional basic authentication information.

    irb> Kronos.api_token = '84bd5f6162c79eb74f3c3d048408bea684cff73898370bacb3eee826e9e5f8ea'
    irb> Kronos.base_uri = 'http://somehost.example.com'
    irb> Kronos.basic_auth('username', 'password') # optional

### Step 4

Make a sample call.

    irb> Kronos::Sample.hello

This should give you

    => Result code: 200, Location:

### Step 5 

Work the machines
  
    irb> Kronos::VirtualMachine.all

This will give you results like:

    [#<Kronos::VirtualMachine:0x11c6ec4 @attributes={"name"=>"Host10", "template_uuid"=>"8af83d0beeb35605bb1b803d15832414", "resource_configuration_uuid"=>"d979bc02aeda53bf9bc3878a4ef2436e", "template_name"=>"EL5-64", "uuid"=>"00000010000000000000000000000000", "zone_uuid"=>nil, "zone_name"=>"us1", "resource_configuration_name"=>"1 CPU, 1024MB RAM, 80GB Disk", "ip_address"=>"10.10.102.110", "state"=>"powered_off"}>, #<Kronos::VirtualMachine:0x11c6eb0 @attributes={"name"=>"Host11", "template_uuid"=>"8af83d0beeb35605bb1b803d15832414", "resource_configuration_uuid"=>"bb6d88778e1150c99cf5c75347852a85", "template_name"=>"EL5-64", "uuid"=>"00000011000000000000000000000000", "zone_uuid"=>nil, "zone_name"=>"us1", "resource_configuration_name"=>"1 CPU, 1024MB RAM, 80GB Disk", "ip_address"=>"10.10.102.111", "state"=>"powered_off"}>, #<Kronos::VirtualMachine:0x11c6e9c @attributes={"name"=>"Host99", "template_uuid"=>"8af83d0beeb35605bb1b803d15832414", "resource_configuration_uuid"=>"b3bdcf9388c458e3907fff3f66421a52", "template_name"=>"EL5-64", "uuid"=>"00000099000000000000000000000000", "zone_uuid"=>nil, "zone_name"=>"us1", "resource_configuration_name"=>"1 CPU, 1024MB RAM, 80GB Disk", "ip_address"=>"10.10.102.111", "state"=>"destroyed"}>]

You could also do:

    irb> Kronos::Template.all
    irb> Kronos::Zone.all
    irb> Kronos::ResourceConfiguration.all

If you know the UUID to any model, you can use `Kronos::Template.find_by_uuid('youruuid')` to find it specifically

## Creating a Virtual Machine

### Step 1, find a zone.

    irb> zone = Kronos::Zone.all.first

### Step 2, find a resource configuration.

    irb> resource_config = Kronos::ResourceConfiguration.all.first

### Step 3, find a template.

    irb> template = Kronos::Template.all.first

### Now, let's create the vm:

    irb> vm = Kronos::VirtualMachine.create!(:name => "My Cool VM", :resource_configuration_uuid => resource_config.uuid, :template_uuid => template.uuid, :zone_uuid => zone.uuid)

### This vm object is a snapshot, so we have to reload it to get the latest status until the state is "powered_on".

    irb> vm.poll_until_create_finished!

### After ~5 minutes you should have a newly created and powered on vm.

    irb> vm.state # should return 'powered_on'

## Changing or destroying an existing Virtual Machine

### Step 1, get the vm.

    irb> vm = Kronos::VirtualMachine.find_by_uuid("some-vm-uuid")

### Step 2, get the current state.

    irb> vm.state  # (see below for valid state values)

### Step 3, you can power on/off, reboot, or suspend/restart a vm:

    irb> vm.stop!
    irb> vm.start!
    irb> vm.suspend!
    irb> vm.start!
    irb> vm.reboot!

Note that in all cases, these can take several seconds to complete.  You'll probably want to do something like this until you get the state you want:
  
    irb> vm.reload.state

### Step 3, before resizing or destroying a vm you must first power it off.

    irb> vm.stop!
    irb> vm.reload.state # repeat until "powered_off"

### Step 4, you can resize a vm by giving it a new ResourceConfiguration.

    irb> new_resource_configuration = Kronos::ResourceConfiguration.find_by_uuid("some other UUID  ")
    irb> vm.resize!(new_resource_configuration)
  
The vm MUST be powered off, and it takes several seconds to resize.
  
### Lastly, you can destroy a powered-off vm.

    irb> vm.destroy!
    irb> vm.reload.state # will print "destroyed"

## Known Virtual Machine states:

* pending_deploy
* powered_on
* powered_off
* pending_start
* pending_stop
* pending_suspend
* suspended
* destroyed
