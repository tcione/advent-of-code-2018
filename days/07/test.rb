require_relative '../../lib/tester.rb'
require_relative './instructions_parser.rb'

def test_question_1
  result = InstructionsParser
           .ordered_instructions(data_source: './test-input.txt')

  puts Tester.test_clause(expected: 'CABDFE',
                          result: result)
end

def test_question_2
  result = InstructionsParser
           .time_to_complete(data_source: './test-input.txt',
                             workers_count: 2)

  puts Tester.test_clause(expected: 15,
                          result: result)
end

test_question_1
test_question_2
