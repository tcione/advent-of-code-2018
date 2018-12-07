require_relative '../../lib/tester.rb'
require_relative './reactor.rb'

def test_question_1
  reactor = Reactor.new(data_source: './test-input.txt')
  puts Tester.test_clause(expected: 'dabCBAcaDA',
                          result: reactor.final_polymer)
end

def test_question_2
  reactor = Reactor.new(data_source: './test-input.txt',
                        reactor_type: :destructive)

  puts Tester.test_clause(expected: 'daDA',
                          result: reactor.final_polymer)
end

test_question_1
test_question_2
