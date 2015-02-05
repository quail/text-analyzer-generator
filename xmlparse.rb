require 'stringio'
require 'ox'

class Actor < ::Ox::Sax
  def initialize()
	@state=[]
  end
  def start_element(name); @state<<name; end
  def end_element(name); @state.pop; end
  def text(txt)
	if(@state==[:mediawiki, :page, :revision, :text])
		print txt
	end
  end
end
fd=IO.sysopen("16mb.xml","r")
io=IO.new(fd)
puts "before parse"
Ox.sax_parse(Actor.new(), io)
puts "after parse"
# outputs
# before parse
# top
# middle
# bottom
# after parse
