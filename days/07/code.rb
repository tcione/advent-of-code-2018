require_relative './instructions_parser.rb'

def question_1
  result = InstructionsParser
           .ordered_instructions(data_source: './input.txt')

  p "question1: #{result}"
end

def question_2
  p "question2: PENDING"
end

question_1
question_2
