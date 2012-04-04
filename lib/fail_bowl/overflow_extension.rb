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

    def hotlist
      calls.
        select { |e| e.type == 'c-call' }.
        sort_by { |e| [ e.klass, e.id ] }.
        chunk { |e| [e.klass, e.id] }.
        map { |sig, events| { "#{sig[0]}.#{sig[1]}" => events.size } }.
        sort_by { |h| h.values.first }.
        reverse
    end
  end
end
