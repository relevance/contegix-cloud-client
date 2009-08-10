module Kronos

  module HTTPartyExtensions

    def invalid?
      @code == 422
    end

    def inspect
      "Result code: #{self.code}, Location: #{self.headers['location']}"
    end

  end

end

HTTParty::Response.send(:include, Kronos::HTTPartyExtensions)
