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
g = X.new("Pat")
g.sayHi
end