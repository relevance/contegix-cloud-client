module Kronos

  class VirtualMachine
    include Api
    MaximumPollTime = 8.minutes

    def self.create!(options={}) 
      if options.nil? || options.empty?
        raise(ArgumentError, "Cannot create a virtual machine from an empty list of options.")
      end

      response = post("/virtual_machines", :query => { :virtual_machine => options })

      if response.invalid?
        errors = response.map { |e| e.join(" ") }
        errors_as_string = errors.join(", ") 
        raise InvalidRequest, errors_as_string
      else
        new response
      end
    end

    def poll_until_create_finished!
      @polling_seconds = 0
      while(self.state == 'pending_deploy')
        @polling_seconds += 15
        sleep 15
        raise "Maximum polling timeout reached waiting for create to finish" if @polling_seconds > MaximumPollTime
        self.reload
      end
    end
    
    def resource_configuration
      ResourceConfiguration.find_by_uuid(self.resource_configuration_uuid)
    end

    def template
      Template.find_by_uuid(self.template_uuid)
    end

    def zone
      Zone.find_by_uuid(self.zone_uuid)
    end

    def resize!(new_resource_configuration)
      self.class.put "/virtual_machines/#{uuid}", 
                     :query => { :virtual_machine => { :resource_configuration_id => new_resource_configuration.uuid } }
    end

    def stop!
      self.class.put "/virtual_machines/#{uuid}/stop"
    end

    def start!
      self.class.put "/virtual_machines/#{uuid}/start"
    end

    def reboot!
      self.class.put "/virtual_machines/#{uuid}/reboot"
    end

    def suspend!
      self.class.put "/virtual_machines/#{uuid}/suspend"
    end

    def destroy!
      self.class.delete "/virtual_machines/#{uuid}"
    end
    
  end

end
