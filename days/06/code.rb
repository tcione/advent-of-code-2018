require_relative './coords_mapper.rb'

def question_1
  mapper = CoordsMapper.new(data_source: './input.txt')

  p "question1: #{mapper.biggest_finite_area}"
end

def question_2
  mapper = CoordsMapper.new(data_source: './input.txt')

  p "question2: #{mapper.area_within_all_reaches(10_000)}"
end

question_1
question_2
