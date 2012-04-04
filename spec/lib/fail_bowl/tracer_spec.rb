require_relative '../../../lib/fail_bowl'

describe FailBowl::Tracer do

  context '#trace_func' do
    it 'returns a proc' do
      subject.trace_func.should be_a(Proc)
    end

    it '...that delegates to self.trace' do
      subject.should_receive(:trace).with('foo')
      subject.trace_func.call('foo')
    end
  end

  context '#trace' do
    it 'stashes events' do
      expect { subject.trace('event', 'file', 'line', 'id', 'binding', 'classname') }.to \
        change { subject.to_a.size }.from(0).to(1)
    end
  end

  context '#to_s' do
    it 'concatenates stringified events' do
      subject.stub!(:to_a => [ :a, :c, :b ])
      subject.to_s.should == "a\nc\nb"
    end
  end

  context '#to_file' do
    it 'writes strigified events to a file' do
      subject.stub!(:to_a => [ :a, :c, :b ])
      ro, wo = IO.pipe
      subject.to_file(wo)
      ro.read.should == "a\nc\nb\n"
    end
  end

  context '#to_graph' do
    it 'delegates to GraphNode#root' do
      events = [:a, :c, :b]
      subject.stub!(:to_a => events)
      FailBowl::GraphNode.should_receive(:root).with(events)
      subject.to_graph
    end
  end

end

describe FailBowl::Tracer::Event do

  context '#to_s' do
    FailBowl::Tracer::Event.new('c-call', '(irb)', 13, :set_trace_func, Object.new, Kernel).to_s.should == 
      "  c-call (irb):13   Kernel.set_trace_func"
  end
end
