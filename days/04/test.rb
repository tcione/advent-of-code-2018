require_relative './guard-picker.rb'
require_relative '../lib/tester.rb'

def test_strategy_most_minutes_asleep
  picker = GuardPicker.new(data_source: './test-input.txt')
  picker.pick

  expected = 10 * 24
  result = picker.guard_minute_id

  puts Tester.test_clause(expected: expected,
                          result: result)
end

def test_strategy_most_occurrences_at_minute
  picker = GuardPicker.new(data_source: './test-input.txt',
                           strategy: :most_occurrences_at_minute)
  picker.pick

  expected = 99 * 45
  result = picker.guard_minute_id

  puts Tester.test_clause(expected: expected,
                          result: result)
end

test_strategy_most_minutes_asleep
test_strategy_most_occurrences_at_minute
