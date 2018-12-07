require_relative '../lib/tester.rb'
require_relative './reactor.rb'

def test_question_1
  puts Tester.test_clause(expected: 'PENDING',
                          result: 0)
end

def test_question_2
  puts Tester.test_clause(expected: 'PENDING',
                          result: 0)
end

test_question_1
test_question_2
