module FailBowl
  module OverflowExtension
    attr_accessor :trace 
    
    def calls
      trace.to_a
    end

    def call_log(file=nil)
      return trace.to_file(file) unless file.nil?
      trace.to_s
    end

    def call_graph
      trace.to_graph
    end
  end
end
