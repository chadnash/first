# it does not seem worth it to make classes of everything especially because the various case statements clarify the alternatives and avoid mistakes
# see allclasses for a demonstration that I can  do classes for all
class Robot
  def initialize()
    @isOnTable=false
  end

  def left
    return unless @isOnTable

    @heading =
        case @heading
          when :north then  :west
          when :south then  :east
          when :east then   :north
          when :west then   :south
        end

  end

  def right
    return unless @isOnTable

    @heading =
        case @heading
          when :north then  :east
          when :south then  :west
          when :east then   :south
          when :west then   :north
        end

    #@heading=:east if @heading==:north
    #@heading=:west if @heading==:south
    #@heading=:south if @heading==:east
    #@heading=:north if @heading==:west

  end

  def move
    return unless @isOnTable

    proposedX, proposedY = @x, @y
    if @heading==:north then
      proposedX, proposedY=proposedX, proposedY+1
    elsif @heading==:south
      proposedX, proposedY=proposedX, proposedY-1
    elsif @heading==:east
      proposedX, proposedY=proposedX+1, proposedY
    elsif @heading==:west
      proposedX, proposedY=proposedX-1, proposedY
    end
    @x, @y =constrainedX(proposedX), constrainedY(proposedY)
  end

  def place(x, y, heading)
    if x==constrainedX(x) && y==constrainedY(y) && isValid(heading)
      @x, @y, @heading, @isOnTable= x, y, heading, true
    end
  end

  def report()
    puts "${@x} ${@y} ${@heading}"
  end

  def executeCommands(commands)
    commands.executeOnRobot(self);
  end

  def constrainedX(x)
    return max(min(x, 5), 0)
  end

  def constrainedY(y)
    return max(min(y, 5), 0)
  end

  def min(*args)
    args.min
  end

  def max(*args)
    args.max
  end

end

class TestRobot
  def test1

  end
end
