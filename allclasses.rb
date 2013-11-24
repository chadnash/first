module Robot
  class Command

  end

  class Place < Command
  end
  class Move < Command
  end
  class Report < Command
  end
  class Left < Command
  end
  class Right < Command
  end


  class Heading
    def turn
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
  end

  $east=Heading.new
  class << $east
    def turnedLeft
      north
    end
    def turnedRight
      $south
    end
    def moveXy
      [1,0]
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
  end



  class Position

  end

