Feature: Traces a block

  As a developer of ruby
  I want to trace the method calls in a block
  So that I can debug stack overflows

  Scenario: Can trace arbitrary code in a block
    Given problematic code
    When I wrap it with FailBowl's block
    Then it traces and logs all method calls and return values

  Scenario: StackOverflows are augmented with information
    Given I am tracing some code with FailBowl
    When it raises a StackOverflow exception
    Then it should be augmented with trace information

  Scenario: Complains about non-augmented code
    Given I am tracing some code with FailBowl
    When it completes without raising a StackOverflow exception
    Then it should raise an exception

