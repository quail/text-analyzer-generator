require_relative 'automota'
require 'set'

class SmallAutomota < Automota
  def initialize
    @forward = Hash.new()
    @reverse = Hash.new()
    @start = nil
  end

  def start
    return @start
  end

  def start=(state)
    @start = state
  end

  def addEdge(fromState,toState,emit,probability)
    if @start == nil then
      @start = fromState
    end
    if not @reverse.has_key?(toState) then
      @reverse[toState] = Set.new()
    end
    @reverse[toState].add(fromState)

    if not @forward.has_key?(fromState) then
      @forward[fromState] = Hash.new()
    end
    if not @forward[fromState].has_key?(toState) then
      @forward[fromState][toState] = Hash.new()
    end
    if not @forward[fromState][toState].has_key?(emit) then
      @forward[fromState][toState][emit] = probability
    else
      @forward[fromState][toState][emit] += probability
    end
  end

  def reverse(toState)
    if not @reverse.has?(toState) then
      return Set.new()
    else
      return @reverse[toState]
    end
  end

  def forward(fromState)
    if not @forward.has_key?(fromState) then
      return []
    else
      ans = []
      @forward[fromState].each do |toState,emits|
        emits.each do |emit,probability|
          ans << [toState,emit,probability]
        end
      end
      return ans
    end
  end

  def to_s
    ans = "start=#{start}\n"
    @forward.each do |from, tos|
      ans << "#{from}->#{tos}\n";
    end
    return ans
  end
end
