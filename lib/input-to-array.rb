# Module to expose an input.txt line by line
module InputLineIterator
  module_function

  def each_line(file_path, sorted: false)
    read = File.readlines(file_path)

    if sorted
      read.sort.each { |line| yield(line) }
      return
    end

    read.each { |line| yield(line) }
  end
end
