require_relative '../../lib/tester.rb'
require_relative './instructions_parser.rb'

def test_question_1
  result = InstructionsParser
           .ordered_instructions(data_source: './test-input.txt')

  puts Tester.test_clause(expected: 'CABDFE',
                          result: result)
end

def test_question_2
  puts Tester.test_clause(expected: 'PENDING',
                          result: 0)
end

test_question_1
test_question_2
