require_relative './productions_slices.rb'

def get_slices
  slices = ProductionSlices.new(width: 1000,
                                height: 1000,
                                orders_file: './input.txt')

  slices.map_fabric

  slices
end

slices = get_slices

p "Overlap: #{slices.overlap_area}"
p "Isolated ids: #{slices.lonesome_ids}"
