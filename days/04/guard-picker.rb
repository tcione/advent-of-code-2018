require_relative '../../lib/input-to-array.rb'

# Class to discover which guard is most likelly to
# be sleeping at a specific minute
class GuardPicker
  def initialize(data_source:, strategy: :most_minutes_asleep)
    @data_source = data_source
    @strategy = strategy
    @guards_naps = {}
    @target_guard_id = nil
    @target_minute = nil
  end

  # Sample data to parse:
  # [1518-05-08 00:02] Guard #659 begins shift
  # [1518-06-09 00:52] falls asleep
  # [1518-07-27 00:59] wakes up
  def parse
    current_guard_id = nil

    InputLineIterator.each_line(@data_source, sorted: true) do |line|
      r_date = '\d{4}\-(?<date>[\d\-]+?)'
      r_time = '(?<time>[\d:]+?)'
      r_action = '(?<action>.*?)'
      regex = /^\[#{r_date} #{r_time}\] #{r_action}$/
      matches = regex.match(line.chomp)

      date = matches[:date]
      minute = matches[:time].split(':').last.to_i

      if line.include?('Guard')
        id = matches[:action].gsub(/.*?(#\d+?) .*?$/, '\1')
        @guards_naps[id] ||= []
        current_guard_id = id
        next
      end

      if line.include?('asleep')
        @guards_naps[current_guard_id] << {
          date: date,
          minute: minute
        }
        next
      end

      asleep_data = @guards_naps[current_guard_id].last
      asleep_minute = asleep_data[:minute] + 1

      while asleep_minute < minute
        @guards_naps[current_guard_id] << {
          date: date,
          minute: asleep_minute
        }
        asleep_minute += 1
      end
    end
  end

  def discover_sleepiest_guard
    sleep_counts = @guards_naps.values.map(&:length)
    @guards_naps.keys[sleep_counts.find_index(sleep_counts.max)]
  end

  def minutes_counters_per_guard(fixed_guard_id = nil)
    guards = fixed_guard_id ? [fixed_guard_id] : @guards_naps.keys
    napiest_of_napiest_minute = nil
    napiest_of_napiest_guard = nil
    napiest_of_napiest_count = -1

    guards.each do |guard_id|
      minutes_count = {}

      sleep_log = @guards_naps[guard_id]

      sleep_log.each do |item|
        key = item[:minute].to_s
        minutes_count[key] ||= 0
        minutes_count[key] += 1
      end

      max_minutes = minutes_count.values

      next if max_minutes.length == 0

      keys = minutes_count.keys

      napiest_count = max_minutes.max
      napiest_minute = keys[max_minutes.find_index(napiest_count)]

      next unless napiest_count > napiest_of_napiest_count

      napiest_of_napiest_count = napiest_count
      napiest_of_napiest_minute = napiest_minute
      napiest_of_napiest_guard = guard_id
    end

    {
      count: napiest_of_napiest_count.to_i,
      minute: napiest_of_napiest_minute.to_i,
      guard_id: napiest_of_napiest_guard.gsub(/\D/, '').to_i
    }
  end

  def pick
    parse

    if @strategy == :most_minutes_asleep
      sleepiest_guard = discover_sleepiest_guard
      counts = minutes_counters_per_guard(sleepiest_guard)

      @target_guard_id = counts[:guard_id]
      @target_minute = counts[:minute]
      return
    end

    counts = minutes_counters_per_guard(sleepiest_guard)
    @target_guard_id = counts[:guard_id]
    @target_minute = counts[:minute]
  end

  def guard_minute_id
    @target_guard_id * @target_minute
  end
end
