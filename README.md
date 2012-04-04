# FailBowl

FailBowl is a simple Gem which helps you find the source 
of that pesky stack overflow that many ORMs are so keen
to send us.

## Installation

Add this line to your application's Gemfile:

    gem 'fail_bowl'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fail_bowl

## Usage

To use FailBowl simply call:

    stack_overflow = FailBowl.trace do 
      # suspicious code
    end

Since tracing every call produces a lot of output it's
usually a good idea to try and reduce the amount of code
you are suspicious of as much as possible before passing
it through FailBowl.

If the enclosed code does not raise a `SystemStackError`
then FailBowl will raise an exception telling you so.
Otherwise FailBowl will return a `SystemStackError` object
which has been augmented with a bunch of useful methods:

  - `#call_log`
    provides a text-based representation of the calls
    made during the trace. Returns a string, or 
    if a file object is passed as an argument writes
    the contents to that instead.

  - `#calls`
    returns a (large) array of tracing events in case
    you need more information.

  - `#call_graph`
    provides a nested tree of call events to make
    it easy to trace execution paths.

  - `hotlist`
    returns a sorted list of method calls and 
    call counts.

## Copyright

FailBowl is copyright (c) 2012, Sociable Limited and
licensed under the terms of the MIT license.  See the
LICENSE file in this distribution for details.

## Contributors

  - James Harton, Sociable Limited <james@sociable.co.nz>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
