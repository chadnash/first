  #Enum by classes

  class Class
     def directSubclassesSince
       #puts "#{self}->#@directSubclassesSince"
       @directSubclassesSince ||= []
     end
    def allDescendantsSince
      all = []
      #puts "1#{self}->#@directSubclassesSince"
      #puts "2#{self}->#{directSubclassesSince}"
      directSubclassesSince.each {|subclass|
        all = all << subclass
        all = all | subclass.allDescendantsSince}
      return all
    end
    def randomSubclass
      allDescendantsSince().randomElement;

    end

    def inherited(subclass)
      #not sure how to force any other implementation of inherited to be called as well
      self.directSubclassesSince << subclass

      #puts "inherited #{self}->#@directSubclassesSince"
    end

  end
  class Array
      def collect_if_not_nil(&elementToCollectBlock)
          return self.collect(&elementToCollectBlock).select {|e| !e.nil?}
      end
      def randomElement
        return self[rand(self.size)]
      end
  end

  class String
    def asCommand
      return Command.fromStringOrNil(self)
    end
    def randomishChange
       return randomOneCharChange if rand(5)==0
       return ""
    end
    def randomOneCharChange
      changed=self.clone

      if rand(3)==0   # 1 time in 3 replace a character
         changed[rand(changed.size)]= String.randomAsciiOfLength(1)
      elsif rand(2)==0 # 1 time in 3 delete a character - there are two chances left
         changed[rand(changed.size)]=''

      else    #  1 time in 3 add a character
        index = rand(changed.size)
        changed[index]= (changed[index]<< String.randomAsciiOfLength(1))
      end


      return changed

    end
    def self.randomAsciiOfLength(length)
      raise "cant be zero or negative length"   if length<1
      return rand(128).chr if length ==1
      return randomAsciiOfLength(length-1)<< randomAsciiOfLength(1)


    end

  end
  class Command

    def self.fromStringOrNil(s)
      commandElements =  s.strip.split(/[ ,]/)
      return nil if commandElements.size<1
      commandName = commandElements.first.strip
      commands = self.allDescendantsSince.collect_if_not_nil {
          |clazz|
        clazz.fromCommandNameAndCommandElementsOrNil(commandName,commandElements)
      }
      raise if commands.size>1
      return commands.first if commands.size==1
      return nil
    end
    def asCommand()
      return self
    end
    def self.randomCommandInputLine
      randomCommandType= self.randomSubclass
      while randomCommandType.equal?(Place) && rand(10)!=0
        randomCommandType= self.randomSubclass    #only choose place 1 in 10 times it is chosen
      end
      inputLine = randomCommandType.randomInputLine()
      inputLine=inputLine.randomishChange() if rand(10)==0
      return inputLine
    end


  end


  class Place < Command
    def initialize(heading ,position)
      @heading,@position=heading,position
    end
    def executeOn(robot)
        return robot.place(@heading,@position)
    end
    def self.fromCommandNameAndCommandElementsOrNil(commandName,commandElements)

      return nil if commandName != "PLACE"
      return nil if commandElements.size!= 4
      position = PositionOnTable.fromTwoStringsAndOnTableOrNil(commandElements[1],commandElements[2]);
      heading=  Heading.fromStringOrNil(commandElements[3].strip)
      return nil  if  heading.nil? || position.nil?  || position.notOnTable?
      return self.new(heading,position)
    end
    def self.randomInputLine()
      return "PLACE #{rand(8)-1},#{rand(8)-1},#{Heading.random}"
    end


  end
  class Move < Command
    def executeOn(robot)
      return robot.moveIfOnTable()
    end
    def self.fromCommandNameAndCommandElementsOrNil(commandName,commandElements)
      return nil if commandName != "MOVE" || commandElements.size>1
      return Move.new()
    end
    def self.randomInputLine()
      return "MOVE"
    end
  end
  class Report < Command
    def executeOn(robot)
      return robot.reportIfOnTable()
    end
    def self.fromCommandNameAndCommandElementsOrNil(commandName,commandElements)
      return nil if commandName != "REPORT" || commandElements.size>1
      return Report.new()
    end
    def self.randomInputLine()
      return "REPORT"
    end
  end
  class Left < Command
    def executeOn(robot)
      return robot.turnLeftIfOnTable()
    end
    def self.fromCommandNameAndCommandElementsOrNil(commandName,commandElements)
      return nil if commandName != "LEFT" || commandElements.size>1
      return Left.new()
    end
    def self.randomInputLine()
      return "LEFT"
    end
  end
  class Right < Command
    def executeOn(robot)
      return robot.turnRightIfOnTable()
    end
    def self.fromCommandNameAndCommandElementsOrNil(commandName,commandElements)
      return nil if commandName != "RIGHT" || commandElements.size>1
      return Right.new()
    end
    def self.randomInputLine()
      return "RIGHT"
    end
  end



  #Enum by  singleton classes
  class Heading
    def self.headings
      @@headings ||=[]
      return @@headings
    end
    def self.random
      return @@headings.randomElement
    end
    def initialize()
       self.class.headings<<self
    end

    def self.fromStringOrNil(s)
      heading = self.headings.detect { |h| h.name == s.strip  }
      return heading
    end
    def to_s
      return "#{name}"
    end

  end


  $north=Heading.new
  class << $north
    def turnedLeft
      $west
    end
    def turnedRight
      $east
    end
    def moveXy
      [0,1]
    end
    def name
      return "NORTH"
    end

  end

  $south=Heading.new
  class << $south
    def turnedLeft
      $east
    end
    def turnedRight
      $west
    end
    def moveXy
      [0,-1]
    end
    def name
      return "SOUTH"
    end
  end


  $east=Heading.new
  class << $east
    def turnedLeft
      $north
    end
    def turnedRight
      $south
    end
    def moveXy
      [1,0]
    end
    def name
      return "EAST"
    end
  end


  $west=Heading.new
  class << $west
    def turnedLeft
      $south
    end
    def turnedRight
      $north
    end
    def moveXy
      [-1,0]
    end
    def name
      return "WEST"
    end
  end



  class PositionOnTable
     def initialize(x,y)
       @xy=[x,y]
     end
     def moved(heading)
        x= @xy.first+heading.moveXy.first
        y=@xy.last+heading.moveXy.last
        return PositionOnTable.new(x,y)  unless self.class.notOnTable?(x,y)
        return self
     end
    def  to_s_unbracketed
      return "#{@xy.first.to_s},#{@xy.last.to_s}"
    end
     def to_s
       "#{@xy}"

     end
    def self.fromTwoStringsAndOnTableOrNil(xs,ys)
      x =xs.to_i
      y =ys.to_i
      #make sure the number strings are just numbers
      return nil if  x.to_s != xs.strip || y.to_s != ys.strip
      return nil if self.notOnTable?(x,y)
      return self.new(x,y)
    end
    def notOnTable?
      return self.class.notOnTable?(@xy.first,@xy.last)
    end
    def self.notOnTable?(x,y) 
      return x<0 || x>5 ||y<0 ||y>5
    end 
    
    

  end

  class Robot2
    def self.run
      r= self.new
      ARGF.each_line do |s|
        cmd = Command.fromStringOrNil(s)
        report=nil
        report = cmd.executeOn(r) unless cmd.nil?
        puts report unless report.nil?
      end
    end

    def to_s
      return "#{@heading} #{@position}"
    end
    def onTable
      return !@position.nil?
    end
    def executeCommands(commands)
      return commands.executeOn(self) if commands.respond_to?(:executeOn)
      return self.executeCommands(Commands.new(commands)) if commands.respond_to?(:each)
      return self.executeCommands(Commands.fromString(commands))

    end
=begin
 (def heading()    @heading    end
    def heading=(headingX)
      #raise "heading must be a Heading" if headingX.class.equals Heading
      #raise "heading cant be nil" if headingX.nil?
      @heading=headingX
    end
    def position()    @position    end
    def position=(position)    @position=position    end
=end
def place(headingX,positionX)
      @heading= headingX
      @position=positionX

     #puts "at end of #{__method__}  robot = #{self}"
      return nil
    end

    def moveIfOnTable()
      @position = @position.moved(@heading) if onTable
      #puts "at end of #{__method__}  robot = #{self.to_s}"
      return nil
    end
    def turnLeftIfOnTable()
      @heading=@heading.turnedLeft  if onTable
      #puts "at end of #{__method__}  robot = #{self.to_s}"
      return nil
    end
    def turnRightIfOnTable()
      @heading=@heading.turnedRight  if onTable
      #puts "at end of #{__method__}  robot = #{self.to_s}"
      return nil
    end
    def reportIfOnTable()
      return "#{@position.to_s_unbracketed},#{@heading.name}"  if onTable
      #puts "at end of #{__method__}  robot = #{self.to_s}"
      return nil
    end

  end

  class Commands
    include Enumerable
    def initialize(commands)
       @commands=commands.collect_if_not_nil{|c|
         if c.nil?
           puts c
         end
         c.asCommand
       }
    end
    def each(&block)
      @commands.each(&block)
    end
    def executeOn(robot)
      return @commands.collect_if_not_nil {|c| c.executeOn(robot)}
      #puts "hi"
    end
    def self.fromString(s)
      commands = s.split("\n")
      return self.new(commands)
    end
    def self.newRandom
      cmds  = 1.to(rand(200)).collect {Command.newRandom}
      return Commands.new(cmds)
    end
    def self.randomCommandsInput
      input = ""

      lines = (1..rand(200)).collect {|i| Command.randomCommandInputLine}
      if (lines.select {|line| !line.index("PLACE").nil?}).size==0
        lines[rand(lines.size)] = Place.randomInputLine  unless rand(5)==0 # ensure there is a place command  most of the time
      end
      lines.each {
      |cmdInput|
        if input.nil?
          input=cmdInput
        else
          input=input << "\n#{cmdInput}"
        end
      }
      return input
    end

  end


  if __FILE__ == $0
    #puts Robot2.new.executeCommands ["PLACE 0,1,WEST", "MOVE", "REPORT"]
   # puts String.randomAsciiOfLength(1)
    Robot2.run

  end




