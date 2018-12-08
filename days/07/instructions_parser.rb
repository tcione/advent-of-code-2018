# Module made to order instructions given by a source file
# I will try to use a more functional approach to this problem :)
# It is important to state that this will not be purelly functional programming
#
# It is also importante to say that the solution ended up rather convoluted,
# but I am pretty tired right now, so I'll call it a day and wrap this thing :)
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

  def available_steps(stack, ignore: [])
    tally = tallied_stack(stack)
    diff = tally[:shouldas].split('') - tally[:befores].split('') - ignore
    diff.uniq.sort
  end

  def last_step(stack)
    tally = tallied_stack(stack)
    diff = tally[:befores].split('') - tally[:shouldas].split('')
    diff.uniq.first
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
    index = ('a'..'z').to_a.find_index(task_name.downcase)
    index + 1 + base_duration
  end

  def workable_steps(stack:,
                     finished_steps:,
                     work_in_progress:,
                     l_step:,
                     workers_count: )
    a_steps = available_steps(stack, ignore: finished_steps)
    steps_in_progress = work_in_progress.keys - finished_steps
    pending_steps = a_steps - steps_in_progress

    w_steps = [].concat(steps_in_progress, pending_steps)
                .slice(0, workers_count)
                .sort

    w_steps.length == 0 ? [l_step] : w_steps
  end

  def update_work_in_progress(stack:,
                              finished_steps:,
                              work_in_progress:,
                              l_step:,
                              workers_count:,
                              base_duration: )

    w_steps = workable_steps(stack: stack,
                             finished_steps: finished_steps,
                             work_in_progress: work_in_progress,
                             l_step: l_step,
                             workers_count: workers_count)

    w_steps.reduce(Hash.new(Float::INFINITY)) do |acc, value|
      next acc if finished_steps.include?(value)

      current_value = work_in_progress[value]
      task_length = time_for_task(value, base_duration)

      new_value = current_value > task_length ? task_length - 1 : current_value - 1

      acc[value.freeze] = new_value
      acc
    end
  end

  def start_task_completion(workers_count:,
                            stack:,
                            base_duration:,
                            l_step:,
                            finished_steps: [],
                            work_in_progress: Hash.new(Float::INFINITY),
                            duration: 0)
    return duration if stack.length == 0 && finished_steps.include?(l_step)

    updated_wip = update_work_in_progress(stack: stack,
                                          finished_steps: finished_steps,
                                          work_in_progress: work_in_progress,
                                          l_step: l_step,
                                          base_duration: base_duration,
                                          workers_count: workers_count)

    just_finished = updated_wip.keys.select do |value|
      updated_wip[value] <= 0
    end

    newly_finished_steps = [].concat(finished_steps, just_finished)
    popped_stack = stack.reject do |item|
      newly_finished_steps.include?(item[:should_finish])
    end

    start_task_completion(workers_count: workers_count,
                          stack: popped_stack,
                          l_step: l_step,
                          base_duration: base_duration,
                          finished_steps: newly_finished_steps,
                          work_in_progress: updated_wip,
                          duration: duration + 1)
  end

  def time_to_complete(data_source:,
                       workers_count: 1,
                       base_duration: 0)
    requirements_from_source(data_source)
      .yield_self do |reqs|
        start_task_completion(workers_count: workers_count,
                              stack: reqs,
                              l_step: last_step(reqs),
                              base_duration: base_duration)
      end
  end
end
