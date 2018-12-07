require_relative './productions_slices.rb'

def slices
  slices = ProductionSlices.new(width: 8,
                                height: 8,
                                orders_file: './test-input.txt')

  slices.map_fabric
  slices.print_canvas

  slices
end

def test_should_calculate_overlap
  area = slices.overlap_area

  return 'test_should_calculate_overlap PASSED' if area == 4

  "test_should_calculate_overlap FAILED :-(. SHOULD BE: 4; IT IS: #{area}"
end

def test_should_get_lonesome_ids
  ids = slices.lonesome_ids
  ok = ids.length == 1 && ids[0] == 3

  return 'test_should_get_lonesome_ids PASSED' if ok

  "test_should_calculate_overlap FAILED :-(. SHOULD BE: [3]; IT IS: #{ids}"
end

p test_should_calculate_overlap
p test_should_get_lonesome_ids
