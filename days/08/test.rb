require_relative '../../lib/tester.rb'
require_relative './tree_parser.rb'

def test_question_1
  result = TreeParser.all_metadata_sum(data_source: './test-input.txt')

  puts Tester.test_clause(expected: 138,
                          result: result)
end

def test_question_2
  result = TreeParser.root_node_value(data_source: './test-input.txt')

  puts Tester.test_clause(expected: 66,
                          result: result)
end

test_question_1
test_question_2
