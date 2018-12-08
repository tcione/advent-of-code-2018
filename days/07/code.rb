require_relative './instructions_parser.rb'

def question_1
  result = InstructionsParser
           .ordered_instructions(data_source: './input.txt')

  p "question1: #{result}"
end

def question_2
  result = InstructionsParser
           .time_to_complete(data_source: './input.txt',
                             base_duration: 60,
                             workers_count: 5)

  p "question2: #{result}"
end

question_1
question_2
