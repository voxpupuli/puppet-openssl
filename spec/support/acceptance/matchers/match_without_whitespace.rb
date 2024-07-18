# frozen_string_literal: true

# based on https://github.com/theforeman/puppet-certs/blob/master/spec/support/acceptance/matchers/match_without_whitespace.rb
# https://github.com/theforeman/puppet-certs/commit/6b82334a5661a4e95b8c0604535ec39c991c9787
RSpec::Matchers.define :match_without_whitespace do |expected|
  match do |actual|
    actual.gsub(%r{\s*}, '').match?(Regexp.new(expected.source, Regexp::EXTENDED))
  end

  failure_message do |actual|
    "Actual:\n\n\s\s#{actual.gsub(%r{\s*}, '')}\n\nExpected:\n\n\s\s#{expected.source}"
  end
end
