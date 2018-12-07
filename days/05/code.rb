require_relative './reactor.rb'

def question_1
  reactor = Reactor.new(data_source: './input.txt')

  p "question1: #{reactor.final_polymer.length}"
end

def question_2
  reactor = Reactor.new(data_source: './input.txt',
                        reactor_type: :destructive)

  p "question2: #{reactor.final_polymer.length}"
end

question_1
question_2
