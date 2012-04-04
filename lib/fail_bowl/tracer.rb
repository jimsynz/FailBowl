module FailBowl
  class Tracer

    class Event
      attr_accessor :type, :file, :line, :id, :binding, :klass, :time
      def initialize(type,file,line,id,binding,klass,time=Time.now)
        @type = type
        @file = file
        @line = line
        @id = id
        @binding = binding
        @klass = klass
        @time = time
      end

      def to_s
        "%8s %s:%-2d %8s.%10s" % [ type, file, line, klass, id ]
      end
    end

    def trace_func
      ->(*args){ self.trace(*args) }
    end

    def trace(*args)
      return if args[1].to_s =~ /half_?full/i
      to_a << Event.new(*args)
    end

    def to_a
      @events ||= []
    end

    def to_s
      to_a.map(&:to_s).join("\n")
    end

    def to_file(file=STDOUT)
      begin
        to_a.each { |e| file.write(e.to_s + "\n")}
        true
      rescue 
        false
      ensure
        file.close
      end
    end

    def to_graph
      GraphNode.root(to_a)
    end

  end
end
