require_relative 'smallautomata'

def SimplePA
  pa = SmallAutomata.new()
  pa.start=:start
  pa.addEdge(:start,:a,'a',(1.0/3.0))
  pa.addEdge(:start,:b,'b',(2.0/3.0))
  pa.addEdge(:a,:a,'a',0.5*(1.0/3.0))
  pa.addEdge(:a,:b,'b',0.5*(2.0/3.0))
  pa.addEdge(:a,:end,'',0.5)
  pa.addEdge(:b,:a,'x',0.5*(1.0/3.0))
  pa.addEdge(:b,:b,'x',0.5*(2.0/3.0))
  pa.addEdge(:b,:end,'',0.5)

  return pa
end
