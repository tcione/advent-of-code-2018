require_relative './tree_parser.rb'

def question_1
  result = TreeParser.all_metadata_sum(data_source: './input.txt')

  p "question1: #{result}"
end

def question_2
  p "question2: PENDING"
end

question_1
question_2
