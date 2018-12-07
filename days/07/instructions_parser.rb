# Module made to order instructions given by a source file
# I will try to use a more functional approach to this problem :)
# It is important to state that this will not be purelly functional programming :o
module InstructionsParser
  module_function

  def parse_data_line(line)
    from = '(?<from>[A-Z])'
    to = '(?<to>[A-Z])'
    reg = /Step #{from} must be finished before step #{to} can begin.$/
    matches = reg.match(line.chomp)

    { should_finish: matches[:from], before: matches[:to] }
  end

  def requirements_from_source(data_source)
    File.readlines(data_source).map { |item| parse_data_line(item) }
  end

  def tallied_stack(stack)
    stack.reduce(Hash.new('')) do |acc, value|
      acc[:shouldas] += value[:should_finish]
      acc[:befores] += value[:before]
      acc
    end
  end

  def available_steps(stack)
    tally = tallied_stack(stack)
    diff = tally[:shouldas].split('') - tally[:befores].split('')
    diff.uniq.sort
  end

  def next_step(stack)
    available_steps(stack).first
  end

  def one_step_further(finished_steps:, stack:)
    n_step = next_step(stack)

    popped_stack = stack.reject { |item| item[:should_finish] == n_step }
    stack_is_empty = popped_stack.length == 0

    next_steps = stack_is_empty ? [n_step, stack[0][:before]] : [n_step]
    newly_finished_steps = [].concat(finished_steps, next_steps)

    {
      finished_steps: newly_finished_steps,
      stack: popped_stack
    }
  end

  def step_by_step(finished_steps: [], stack:)
    return finished_steps if stack.length == 0

    next_step = one_step_further(finished_steps: finished_steps,
                                 stack: stack)

    step_by_step(next_step)
  end

  def ordered_instructions(data_source:)
    requirements_from_source(data_source)
      .yield_self { |reqs| step_by_step(stack: reqs) }
      .yield_self(&:join)
  end

  def time_for_task(task_name, base_duration)
    index = ('a'..'z').to_a.find_index(task.name.downcase)
    index + 1 + base_duration
  end

  def start_task_completion(workers_count:,
                            stack:,
                            base_duration:,
                            finished_steps: [],
                            work_in_progress: Hash.new(false),
                            duration: 0)
    return duration if stack.length == 0
  end

  def time_to_complete(data_source:,
                       workers_count: 1,
                       base_duration: 0)
    0
  end
end
