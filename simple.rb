# it does not seem worth it to make classes of everything especially because the various case statements clarify the alternatives and avoid mistakes
# see allclasses for a demonstration of double dispatching

class Robot
  North,South,East,West="NORTH","SOUTH","EAST","WEST"
  def initialize()
    @isOnTable=false
    @reports=nil
  end

  def leftIfOnTable
    return unless @isOnTable

    @heading =
        case @heading
          when North then  West
          when South then  East
          when East then   North
          when West then   South
        end

  end

  def rightIfOnTable
    return unless @isOnTable

    @heading =
        case @heading
          when North then  East
          when South then  West
          when East then   South
          when West then   North
        end

    #@heading=East if @heading==North
    #@heading=West if @heading==South
    #@heading=South if @heading==East
    #@heading=North if @heading==West

  end

  def moveIfOnTableAndStaysOnTable
    return unless @isOnTable

    proposedX, proposedY = @x, @y
    if @heading==North then
      proposedX, proposedY=proposedX, proposedY+1
    elsif @heading==South
      proposedX, proposedY=proposedX, proposedY-1
    elsif @heading==East
      proposedX, proposedY=proposedX+1, proposedY
    elsif @heading==West
      proposedX, proposedY=proposedX-1, proposedY
    end
    @x, @y =constrainedX(proposedX), constrainedY(proposedY)
  end

  def placeIfItWillBeOntoTable(x, y, heading)
    if x==constrainedX(x) && y==constrainedY(y)
      @x, @y, @heading, @isOnTable= x, y, heading, true
    end
  end

  def reportIfOnTable()
    return unless @isOnTable

    report =  "#@x,#@y,#@heading"


    puts  report
  end
 
  def executeCommands(commands)
    if commands.respond_to?("each") then
        commands.each {  |command| executeCommand command     }
    elsif commands.respond_to?("each_line") then
      commands.each_line {  |command| executeCommand command     }
    end

  end
  def executeCommand(command )
    #puts "command=#{command}"
    #puts "@isOnTable=#@isOnTable"
    commandElements =  command.strip.split(/[ ,]/)
    commandName = commandElements.first.strip

    #ensure non-valid single word commands are ignored
    return if commandElements.size>1 && ["REPORT" , "MOVE" , "LEFT" , "RIGHT"].include?(commandName)

    case commandName
      when "REPORT"  then  self.reportIfOnTable
      when "MOVE"  then  self.moveIfOnTableAndStaysOnTable
      when "LEFT"  then  self.leftIfOnTable
      when "RIGHT"  then  self.rightIfOnTable
      when "PLACE"  then
        return if commandElements.size!= 4
        x =commandElements[1].to_i
        y =commandElements[2].to_i
        heading=  case commandElements[3].strip
                    when "NORTH" then North
                    when "SOUTH" then South
                    when "EAST" then East
                    when "WEST" then West
                  end
        return  if  heading==nil || x.to_s != commandElements[1].strip || y.to_s != commandElements[2].strip
        self.placeIfItWillBeOntoTable(x,y,heading)
    end
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

require "test/unit"
class TestRobot  < Test::Unit::TestCase
  StdoutStandinFilename = "out.txt"
  def initialize(name)
    super(name)
    @stdoutStandIn = File.open(StdoutStandinFilename,"w")
    $stdout=  @stdoutStandIn
    #$stdout.reopen(StdoutStandinFilename, "w")
  end
  def contentOfStdoutOverTest()
    $stdout=STDOUT
    @stdoutStandIn.close
    f = File.open(StdoutStandinFilename,"rb")
    contents = f.read
    f.close

    return contents
  end
  def testSpecCaseA
    r= Robot.new
    r.executeCommands <<-EOF
      PLACE 0,0,NORTH
      MOVE
      REPORT
    EOF
    #puts  "r.reports=#{r.reports}"
    assert_equal(  "0,1,NORTH\r\n",contentOfStdoutOverTest )

  end
  def testSpecCaseB
    r= Robot.new
    r.executeCommands <<-EOF
      PLACE 0,0,NORTH
      LEFT
      REPORT
    EOF

    assert_equal(  "0,0,WEST\r\n" ,contentOfStdoutOverTest )

  end


  def testSpecCaseC
    r= Robot.new
    r.executeCommands <<-EOF
      PLACE 1,2,EAST
      MOVE
      MOVE
      LEFT
      MOVE
      REPORT
    EOF
    assert_equal( "3,3,NORTH\r\n",contentOfStdoutOverTest )

  end
end

