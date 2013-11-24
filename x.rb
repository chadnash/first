class X
def initialize(name = "World")
    @name = name
 end
 def sayHi
  puts "Hi #{@name}!"
 end
def sayBye
   puts "Bye #{@name}, come back soon."
 end

end
class Z
  def initialize(name = "World")
    @name = name
  end
  def sayHi
    puts "Hi #{@name}!"
  end
  def sayBye
    puts "Bye #{@name}, come back soon."
  end

end
if __FILE__ == $0
  g = Z.new "Pat"
  g.sayHi
end

