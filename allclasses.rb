module Robot
  class Command
    executOn(r)
  end

  class Place < Command
    def initialize(heading,position)
      @heading,@position=heading,position
    end
    def executeOn(robot)
        return robot.place(heading,position)
    end

  end
  class Move < Command
    def executeOn(robot)
      return robot.move()
    end
  end
  class Report < Command
  end
  class Left < Command
    def executeOn(robot)
      return robot.turnLeft()
    end
  end
  class Right < Command
    def executeOn(robot)
      return robot.turnRight()
    end
  end

  end


  class Heading

  end

#try out singleton classes
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


  east=Heading.new
  class << east
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
      return EAST
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
      [1,0]
    end
    def name
      return WEST
    end
  end



  class Position
     def initialize(x,y)
       @xy=[x,y]
     end
     def moved(heading)
        return new Position([@xy.first+heading.moveXy.first,@xy.last+heading.moveXy.last])
     end

  end

  class Robot2
    def place(heading,position)
      @position,@heading = heading,position
      return nil
    end

    def executedCommands(commands)
        return commands.executeOn(self)
    end
    def move()
      @position = @position.moved(@heading)
      return nil
    end
    def turnLeft()
      @heading=@heading.turnedLeft
      return nil
    end
    def turnRight()
      @heading=@heading.turnedRight
      return nil
    end
    def report()
      return "#{positon.to_s_unbracketed},#{heading.name}"
    end

  end

  class Commands
    include Enumerable
    def initialize(commands)
      @commands=commands
    end
    def each(&block)
      @commands.each(&block)
    end
    def executeOn(robot)
      return @commands.collect {|c| c.executOn(r)}
    end
    def self.fromString(s)
      commands = s.split("\n").collect {|line| Command.fromString(line) }.reject {|c| c.nil?}
      return self.new(commands)

    end


  end