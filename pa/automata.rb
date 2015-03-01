class Automata
  def initialize
    @random = nil
  end

  def random
    if @random == nil then
      @random = Random.new()
    end
    return @random
  end

  def random=(value)
    @random=value
  end

  def reverse(state)
    return Set.new()
  end

  def forward(state)
    raise "error"
  end

  def start
    return nil
  end

  def likelyhood(emits)
    states = Hash.new()
    states[start]=1.0
    emits.each do |emit|
      nextStates = Hash.new()
      states.each do |at,p|
        options = forward(at)
        total = 0.0
        options.each { |to,emit,weight| total += weight }
        options.each do |to,emit1,weight|
          if emit == emit1 and weight > 0 then
            nextStates[to] = (nextStates[to]||0.0) + p*weight/total
          end
        end
      end
      states = nextStates
    end
    prob = 0.0
    states.each do |at,p|
      if forward(at).length == 0 then
        prob = prob + p
      end
    end
    return prob
  end

  def run(&block)
    rng=random
    prob=1
    at = start
    while true do
      options = forward(at)
      if options.length == 0 then
        break
      end
      total = 0.0
      options.each { |to,emit,weight| total += weight }
      p = total*rng.rand
      options.each do |to,emit,weight|
        if p < weight then
          prob = prob * (weight/total)
          yield emit,(weight/total)
          at=to
          break
        else
          p = p - weight
        end
      end
    end
  end
end
