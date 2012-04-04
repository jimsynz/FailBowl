require_relative "fail_bowl/version"
require_relative 'fail_bowl/tracer'
require_relative 'fail_bowl/overflow_extension'

module FailBowl

  autoload :GraphNode, File.expand_path('../fail_bowl/graph_node', __FILE__)

  class NoStackError < RuntimeError; end

  def self.trace
    tracer = Tracer.new
    begin
      set_trace_func tracer.trace_func
      yield
      raise NoStackError, "the code under test did not overflow the stack"
    rescue SystemStackError => e
      e.extend(OverflowExtension)
      e.trace = tracer
      e
    ensure
      set_trace_func nil
    end
  end
end
