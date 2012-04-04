require_relative '../../../lib/fail_bowl'

describe FailBowl::OverflowExtension do
  let (:tracer) { stub(:tracer) }
  let (:overflow) do
    overflow = Object.new
    overflow.extend(FailBowl::OverflowExtension)
    overflow.trace = tracer
    overflow
  end

  context '.calls' do
    it 'deletegates to Tracer#to_a' do
      tracer.should_receive(:to_a)
      overflow.calls
    end
  end

  context '.call_log' do
    it 'delegates to Tracer#to_s' do
      tracer.should_receive(:to_s)
      overflow.call_log
    end

    it 'delegates to Traver#to_file when given a file argument' do
      file = stub
      tracer.should_receive(:to_file).with(file)
      overflow.call_log(file)
    end
  end

  context '.call_graph' do
    it 'delegates to Tracer#to_graph' do
      tracer.should_receive(:to_graph)
      overflow.call_graph
    end
  end

  context '.hotlist' do
    it 'returns a sorted list of method call frequency' do
      klass = Class.new
      base_event = FailBowl::Tracer::Event.new('c-call', '(irb)', 1, :foo, Object.new, klass)
      hot_event = base_event.dup.tap { |e| e.id = :hot }
      warm_event = base_event.dup.tap { |e| e.id = :warm }
      cold_event = base_event.dup.tap { |e| e.id = :cold }
      tracer.stub(:to_a) { [ hot_event, cold_event, warm_event, hot_event.dup, warm_event.dup, hot_event.dup ] }
      overflow.hotlist.first.should == { "#{klass}.hot" => 3 }
      overflow.hotlist.last.should == { "#{klass}.cold" => 1 }
    end
  end

end
