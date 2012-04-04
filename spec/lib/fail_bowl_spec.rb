require_relative '../../lib/fail_bowl.rb'

describe FailBowl do

  context '.trace' do

    before do
      FailBowl::Tracer = stub.as_null_object unless defined? FailBowl::Tracer
      FailBowl.stub!(:set_trace_func).as_null_object
    end
    let (:recursive_code) { ->{ recursive_code.call}}

    it 'enables tracefunc when executing the block' do
      FailBowl.should_receive(:set_trace_func).exactly(:twice)
      FailBowl.trace &recursive_code
    end

    it 'rescues SystemStackError' do
      expect { FailBowl.trace &recursive_code }.should_not raise_error(SystemStackError)
    end

    it 'raises NoStackError when no stack overflow happens' do
      expect { FailBowl.trace &->{} }.should raise_error(FailBowl::NoStackError)
    end

    it 'augments SystemStackError with call statistics' do
      FailBowl.unstub!(:set_trace_func)
      FailBowl.trace(&recursive_code).calls.should_not be_empty
    end

    it "doesn't trace any methods called within FailBowl" do
      FailBowl.unstub!(:set_trace_func)
      FailBowl.trace(&recursive_code).calls.any? { |e| e.file =~ /fail_?bowl/i }.should be_false
    end

  end
end
