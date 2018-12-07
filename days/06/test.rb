require_relative '../lib/tester.rb'
require_relative './coords_mapper.rb'

def test_question_1
  mapper = CoordsMapper.new(data_source: './test-input.txt')

  puts Tester.test_clause(expected: 17,
                          result: mapper.biggest_finite_area)
end

def test_question_2
  mapper = CoordsMapper.new(data_source: './test-input.txt')

  puts Tester.test_clause(expected: 16,
                          result: mapper.area_within_all_reaches(32))
end

test_question_1
test_question_2
