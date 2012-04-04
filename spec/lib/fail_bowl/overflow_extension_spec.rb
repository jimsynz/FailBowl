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

end
