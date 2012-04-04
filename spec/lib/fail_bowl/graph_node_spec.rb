require_relative '../../../lib/fail_bowl'

describe FailBowl::GraphNode do

  context '.root' do
    let(:call_event) { FailBowl::Tracer::Event.new('c-call', 'file', 1, :foo, Object.new, Class.new)}
    let(:line_event) { FailBowl::Tracer::Event.new('line', 'file', 1, :foo, Object.new, Class.new)}
    let(:return_event) { FailBowl::Tracer::Event.new('c-return', 'file', 1, :foo, Object.new, Class.new)}

    it 'returns a GraphNode instance' do
      FailBowl::GraphNode.root([]).should be_a(FailBowl::GraphNode)
    end

    it 'has zero stack depth' do
      FailBowl::GraphNode.root([]).depth.should == 0
    end

    context 'single call and return' do
      subject { [ call_event, return_event ]}

      it 'has a stack depth of one' do
        FailBowl::GraphNode.root(subject).depth.should == 1
      end
    end

    context 'call, line and return' do
      subject { FailBowl::GraphNode.root([ call_event, line_event, return_event ])}
      it 'has a stack depth of one' do
        subject.depth.should == 1
      end
    end

    context '5 x call & return' do
      subject  do
        FailBowl::GraphNode.root(Array.new(5, call_event) + Array.new(5, return_event))
      end

      it 'has a stack depth of 5' do
        subject.depth.should == 5
      end
    end
  end

  context '#call' do
    it 'sets call details' do
      event = stub(type: 'c-call', file: 'file', line: 1, id: :foo, binding: Object.new, klass: Class.new)
      node = FailBowl::GraphNode.new
      node.call(event)
      node.call.file.should == event.file
      node.call.line.should == event.line
      node.call.method.should == event.id
      node.call.binding.should == event.binding
      node.call.receiver.should == event.klass
    end
  end

  context '#push_call_stack' do
    let (:event) { stub(type: 'c-call', file: 'file', line: 1, id: :foo, binding: Object.new, klass: Class.new) }
    let (:root) { FailBowl::GraphNode.new }
    it 'creates a new node' do
      node = root.push_call_stack(event)
      node.should_not == root
    end

    it "sets the child's call details" do
      node = root.push_call_stack(event)
      node.call.file.should == event.file
      node.call.line.should == event.line
      node.call.method.should == event.id
      node.call.binding.should == event.binding
      node.call.receiver.should == event.klass
    end

    it "sets the child node's parent" do
      node = root.push_call_stack(event)
      node.parent.should == root
    end
  end

  context '#returns' do
    it 'sets the return details' do
      event = stub(type: 'c-call', file: 'file', line: 1, id: :foo, binding: Object.new, klass: Class.new)
      node = FailBowl::GraphNode.new
      node.returns(event)
      node.returns.file.should == event.file
      node.returns.line.should == event.line
      node.returns.method.should == event.id
      node.returns.binding.should == event.binding
      node.returns.receiver.should == event.klass
    end
  end

  context '#push_call_stack' do
    let (:event) { stub(type: 'c-return', file: 'file', line: 1, id: :foo, binding: Object.new, klass: Class.new) }
    let (:root) { FailBowl::GraphNode.new }

    it "sets the parent's return details" do
      root.pop_call_stack(event)
      root.returns.file.should == event.file
      root.returns.line.should == event.line
      root.returns.method.should == event.id
      root.returns.binding.should == event.binding
      root.returns.receiver.should == event.klass
    end

    it "returns the child's parent" do
      node = root.push_call_stack(event)
      parent = node.pop_call_stack(event)
      parent.should == root
    end
  end

  context '#line' do
    let (:event) { stub(type: 'c-return', file: 'file', line: 1, id: :foo, binding: Object.new, klass: Class.new) }
    let (:root) { FailBowl::GraphNode.new }

    it 'creates a new line' do
      line = root.line(event)
      root.lines.should == [line]
    end
  end

end
