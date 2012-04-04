require_relative '../../lib/fail_bowl.rb'


Given /^problematic code$/ do
  @problematic_code = -> do
    @problematic_code.call
  end
end
 
Given /^I am tracing some code with FailBowl$/ do
  pending # express the regexp above with the code you wish you had
end
 
When /^I wrap it with FailBowl's block$/ do
  @trace = FailBowl.trace do
    @problematic_code.call
  end
end
 
Then /^it traces and logs all method calls and return values$/ do
  @trace.call_log.any?
end

When /^it raises a StackOverflow exception$/ do
  pending # express the regexp above with the code you wish you had
end

When /^it completes without raising a StackOverflow exception$/ do
  pending # express the regexp above with the code you wish you had
end
 
Then /^it should be augmented with trace information$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^it should raise an exception$/ do
  pending # express the regexp above with the code you wish you had
end

