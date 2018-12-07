require_relative './guard-picker.rb'

def pick_a_guard1
  picker = GuardPicker.new(data_source: './input.txt')
  picker.pick
  p picker.guard_minute_id
end

def pick_a_guard2
  picker = GuardPicker.new(data_source: './input.txt',
                           strategy: :most_occurrences_at_minute)
  picker.pick
  p picker.guard_minute_id
end

pick_a_guard2
