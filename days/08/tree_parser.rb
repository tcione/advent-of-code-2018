module TreeParser
  module_function

  def clean_data_source(data_source)
    File.readlines(data_source)
        .map(&:chomp)
        .join('')
        .split(' ')
        .map(&:to_i)
  end

  def sum_the_metadata(sequence:,
                       sum: 0)
    children_count = sequence.shift
    meta_count = sequence.shift

    while children_count > 0
      sum, sequence = sum_the_metadata(sequence: sequence, sum: sum)
      children_count -= 1
    end

    while meta_count > 0
      sum += sequence.shift
      meta_count -= 1
    end

    [sum, sequence]
  end

  def calc_root_node_sum(sequence:)
  end

  def root_node_value(data_source:)
    clean_data_source(data_source)
      .yield_self { |seq| calc_root_node_sum(sequence: seq) }
  end

  def all_metadata_sum(data_source:)
    clean_data_source(data_source)
      .yield_self { |seq| sum_the_metadata(sequence: seq) }
      .yield_self { |result| result[0] }
  end
end
