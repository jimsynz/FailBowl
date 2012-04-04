module FailBowl
  class GraphNode

    Call = Struct.new(:file,:line,:method,:binding,:receiver) do
      def initialize(event)
        self.file = event.file
        self.line = event.line
        self.method = event.id
        self.binding = event.binding
        self.receiver = event.klass
      end
    end
    Return = Call
    Line = Call

    attr_accessor :depth, :parent

    def self.root(events)
      root = self.new

      context = root
      events.each do |event|
        case event.type
        when 'c-call'
          root.depth = root.depth + 1
          context = context.push_call_stack(event)
        when 'line'
          context.line(event)
        when 'c-return'
          context = context.pop_call_stack(event)
        end
      end

      root
    end

    def initialize
      self.depth ||= 0
    end

    def call(event=nil)
      @call = Call.new(event) if event
      @call
    end

    def returns(event=nil)
      @returns = Return.new(event) if event
      @returns
    end

    def pop_call_stack(event)
      returns(event)
      parent
    end

    def push_call_stack(event)
      new_node = self.class.new
      new_node.call(event)
      new_node.parent = self
      calls << new_node
      new_node
    end

    def calls
      @calls ||= []
    end

    def line(event)
      line = Line.new(event)
      lines << line
      line
    end

    def lines
      @lines ||= []
    end

  end
end
