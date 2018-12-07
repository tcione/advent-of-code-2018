require_relative '../../lib/input-to-array.rb'

# Helpers for CoordsMapper
module Utilities
  module_function

  def coord_string_to_array(str)
    str.split(',').map { |item| item.chomp.to_i }
  end

  def distance(point_a, point_b)
    (point_a[0] - point_b[0]).abs + (point_a[1] - point_b[1]).abs
  end
end

# Class to map coords and their manhattan distances
class CoordsMapper
  def initialize(data_source:)
    @data_source = data_source
    @_maxes = { x: -Float::INFINITY, y: -Float::INFINITY }
    coords
    map_areas
  end

  def biggest_finite_area
    sizes = map_areas.values
    ids = map_areas.keys
    biggest = -1

    sizes.each_with_index do |size, index|
      area_id = ids[index]
      next if infinite_area?(area_id)
      next if size < biggest
      biggest = size
    end

    biggest
  end

  def area_within_all_reaches(spread_size)
    distance_to_all_points_map.values.reduce(0) { |acc, distances_sum|
      acc += 1 if distances_sum < spread_size
      acc
    }
  end

  private

  def get_or_define(var_name)
    name = "@_private_#{var_name}".to_sym
    return instance_variable_get(name) if instance_variable_defined?(name)
    instance_variable_set(name, yield)
  end

  def stretch_maxes(coord)
    current_x, current_y = coord
    @_maxes[:x] = current_x if current_x > @_maxes[:x]
    @_maxes[:y] = current_y if current_y > @_maxes[:y]
  end

  def coords
    get_or_define('coords') do
      File.readlines(@data_source).map do |item|
        parsed = Utilities.coord_string_to_array(item)
        stretch_maxes(parsed)
        parsed
      end
    end
  end

  def all_distances_to(current_x, current_y)
    destiny = [current_x, current_y]

    coords.reduce(0) { |acc, source|
      acc += Utilities.distance(source, destiny)
      acc
    }
  end

  def shortest_index_to(current_x, current_y)
    shortest_distance = Float::INFINITY
    shortest_index = nil
    destiny = [current_x, current_y]

    coords.each_with_index do |source, coord_index|
      distance = Utilities.distance(source, destiny)

      next if distance > shortest_distance

      if shortest_distance == distance
        shortest_index = -1
        next
      end

      shortest_distance = distance
      shortest_index = coord_index
    end

    shortest_index
  end

  def each_map_coord
    current_y = 0
    current_x = 0

    while current_y <= @_maxes[:y] && current_x <= @_maxes[:x]
      yield(current_x, current_y)

      if current_x == @_maxes[:x]
        current_x = 0
        current_y += 1
        next
      end

      current_x += 1
    end
  end

  def edge_coords
    get_or_define('edge_coords') do
      current_y = 0
      current_x = 0
      max_x = @_maxes[:x]
      max_y = @_maxes[:y]

      e_coords = []

      while current_y <= max_y && current_x <= max_x
        valid_x = current_x == 0 || current_x == max_x
        valid_y = current_y == 0 || current_y == max_y

        e_coords << "#{current_x},#{current_y}" if valid_x || valid_y

        if current_x == max_x
          current_x = 0
          current_y += 1
          next
        end

        current_x += 1
      end

      e_coords
    end
  end

  def closest_indexes_map
    get_or_define('closest_indexes_map') do
      map = {}

      each_map_coord do |current_x, current_y|
        map_id = "#{current_x},#{current_y}"
        shortest_index = shortest_index_to(current_x, current_y)
        map[map_id] = shortest_index
      end

      map
    end
  end

  def distance_to_all_points_map
    get_or_define('distance_to_all_points_map') do
      map = {}

      each_map_coord do |current_x, current_y|
        map_id = "#{current_x},#{current_y}"
        shortest_index = all_distances_to(current_x, current_y)
        map[map_id] = shortest_index
      end

      map
    end
  end

  def infinite_area?(index)
    map = closest_indexes_map
    infinite = false

    edge_coords.each do |coord|
      infinite = map[coord] == index
      break if infinite
    end

    infinite
  end

  def map_areas
    get_or_define('mapped_areas') do
      map = closest_indexes_map

      areas = map.values.reduce(Hash.new(0)) { |acc, area|
        acc[area] += 1
        acc
      }

      areas
    end
  end
end
