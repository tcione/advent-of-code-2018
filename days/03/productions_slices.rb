require 'ostruct'

class ProductionSlices
  def initialize(width:, height:, orders_file:)
    @width = width
    @height = height
    @orders_file = orders_file
    @ids = []
    @overlaps = []

    generate_canvas

    @_extract_regexp = nil
  end

  def canvas
    @_canvas
  end

  def canvas_line
    (1..@width).to_a.map { [] }
  end

  def generate_canvas
    return @_canvas if @_canvas
    @_canvas = (1..@height).to_a.map { canvas_line }
    @_canvas
  end

  def extract_regexp
    return @_extract_regexp if @_extract_regexp

    r_id = '(?<id>\d{1,4})'
    r_top = '(?<top>\d{1,3})'
    r_left = '(?<left>\d{1,3})'
    r_width = '(?<width>\d{1,3})'
    r_height = '(?<height>\d{1,3})'

    @_extract_regexp = /^\##{r_id} \@ #{r_left},#{r_top}: #{r_width}x#{r_height}$/

    @_extract_regexp
  end

  def extract_instructions(line)
    instructions = extract_regexp.match(line)

    OpenStruct.new(id: instructions[:id].to_i,
                   left: instructions[:left].to_i,
                   top: instructions[:top].to_i,
                   width: instructions[:width].to_i,
                   height: instructions[:height].to_i)
  end

  def map_fabric
    File.open(@orders_file, 'r') do |file|
      file.each_line do |line|
        instructions = extract_instructions(line)

        left = instructions.left
        top = instructions.top
        max_left = instructions.width + instructions.left - 1
        max_top = instructions.height + instructions.top - 1

        @ids << instructions.id

        while top <= max_top
          while left <= max_left
            canvas[top][left] << instructions.id
            left += 1
          end

          left = instructions.left
          top += 1
        end
      end
    end
  end

  def print_canvas
    p '==========='
    canvas.each { |line| p line.map(&:length) }
    p '==========='
  end

  def overlap_area
    canvas.map { |item| item.map(&:length) }
          .flatten
          .reject { |item| item <= 1 }
          .length
  end

  def lonesome_ids
    canvas.each do |line|
      line.each do |cell|
        next if cell.length < 2
        @overlaps << cell
      end
    end

    @ids.flatten.uniq - @overlaps.flatten.uniq
  end
end
