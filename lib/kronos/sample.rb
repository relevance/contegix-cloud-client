module Kronos
  class Sample
    include Api
    
    def self.hello
      get("/hello")
    end
  end
end
