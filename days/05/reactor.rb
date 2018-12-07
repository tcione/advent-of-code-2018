require_relative '../lib/input-to-array.rb'

# Class to break coded polymers
class Reactor
  A_TO_Z = ('a'..'z').to_a.freeze

  def initialize(data_source:, reactor_type: :non_destructive)
    @data_source = data_source
    @type = reactor_type
    @polymer = ''
    @reactions_triggered = false
    @removed_problem_agent = false
  end

  def reaction_couples
    A_TO_Z.to_a.map do |char|
      couple = "#{char}#{char.upcase}"
      [couple, couple.reverse]
    end.flatten
  end

  def reaction_couples_regex
    couples = reaction_couples.join('|')
    /(#{couples})/
  end

  def trigger_reactions
    return if @reactions_triggered

    regexp = reaction_couples_regex

    original = File.readlines(@data_source).join('').chomp
    current = nil
    smallest = nil
    problematic_agents = @type == :destructive ? A_TO_Z : [:none]

    problematic_agents.each do |agent|
      p "Breaking with problematic agent: #{agent}"
      current = original
      p "Original length: #{current.length}"
      current = current.gsub(/#{agent}/i, '') unless agent == :none
      p "After problematic agent removal length: #{current.length}"
      current = current.gsub(regexp, '') while regexp.match(current)
      p "After reactions length: #{current.length}"
      smallest = current if !smallest || smallest.length > current.length
    end

    @polymer = smallest

    @reactions_triggered = true
  end

  def final_polymer
    trigger_reactions
    @polymer
  end
end
