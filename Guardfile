guard :rspec, all_after_pass: false, all_on_start: false do
  watch(%r{^lib/(.*)\.rb$}) { |m| "spec/#{m[1]}_spec.rb"}
  watch(%r{^spec/.+_spec\.rb$})
end

