require "test/unit"
require_relative "simple"
require_relative "allclasses"
class TestRobot  < Test::Unit::TestCase
  @@RobotClass = Robot2
  def self.newRobot
    return @@RobotClass.new
  end
  def testSpecCaseA
    r= TestRobot.newRobot
    reports = r.executeCommands <<-EOF
      PLACE 0,0,NORTH
      MOVE
      REPORT
    EOF
    #puts  "r.reports=#{r.reports}"
    assert_equal(  ["0,1,NORTH"],reports )

  end
  def testSpecCaseB
    r= TestRobot.newRobot
    reports=r.executeCommands <<-EOF
      PLACE 0,0,NORTH
      LEFT
      REPORT
    EOF

    assert_equal(  ["0,0,WEST"] ,reports )

  end


  def testSpecCaseC
    r= TestRobot.newRobot
    reports=r.executeCommands <<-EOF
      PLACE 1,2,EAST
      MOVE
      MOVE
      LEFT
      MOVE
      REPORT
    EOF
    assert_equal( ["3,3,NORTH"] ,reports )

  end
  def testLimits
    assert_equal((TestRobot.newRobot.executeCommands ["PLACE 0,1,WEST","MOVE","REPORT"]),["0,1,WEST"])
    assert_equal((TestRobot.newRobot.executeCommands ["PLACE 1,0,SOUTH","MOVE","REPORT"]),["1,0,SOUTH"])
    assert_equal((TestRobot.newRobot.executeCommands ["PLACE 5,1,EAST","MOVE","REPORT"]),["5,1,EAST"])
    assert_equal((TestRobot.newRobot.executeCommands ["PLACE 1,5,NORTH","MOVE","REPORT"]),["1,5,NORTH"])
    assert_equal((TestRobot.newRobot.executeCommands ["PLACE 1,6,NORTH","REPORT"]),[])
    assert_equal((TestRobot.newRobot.executeCommands ["PLACE 6,0,NORTH","MOVE","REPORT"]),[])
    assert_equal((TestRobot.newRobot.executeCommands ["PLACE -1,0,NORTH","MOVE","REPORT"]),[])
    assert_equal((TestRobot.newRobot.executeCommands ["PLACE 6,-1,NORTH","MOVE","REPORT"]),[])

  end
  def testLeft
    assert_equal((TestRobot.newRobot.executeCommands ["PLACE 0,1,WEST","LEFT","LEFT","LEFT","LEFT","REPORT"]),["0,1,WEST"])
  end
  def testRight
    assert_equal((TestRobot.newRobot.executeCommands ["PLACE 0,1,WEST","RIGHT","RIGHT","RIGHT","RIGHT","REPORT"]),["0,1,WEST"])
  end
  def testRightAndLeft
    excessOfLefts=0
    commands =   ["PLACE 0,1,WEST"]
   for i in 1..6
      lefts=rand(6)
      rights=rand(6)
      excessOfLefts=excessOfLefts+lefts-rights
      commands= (commands + (["LEFT"]*lefts)) + (["RIGHT"]*rights)
    end
    commands = commands  + (["RIGHT"]*excessOfLefts)   if excessOfLefts>0
    commands = commands  + (["LEFT"]*(-excessOfLefts)) if    excessOfLefts<0
    commands = commands  << "REPORT"
    assert_equal(TestRobot.newRobot.executeCommands(commands),["0,1,WEST"])
  end

  def testSquare()
    r= TestRobot.newRobot
    reports=r.executeCommands <<-EOF
      PLACE 2,2,NORTH
      MOVE
      LEFT
      MOVE
      LEFT
      MOVE
      LEFT
      MOVE
      LEFT
      REPORT
    EOF
    assert_equal( ["2,2,NORTH"] ,reports )
  end
  def testRobot2NoExceptions
    srand(1)
    r=Robot2.new
    r.executeCommands(Commands.randomCommandsInput)
  end

  def testRobotsAgainstEachOtherFor1RandomCommand
    srand(1)
    r1= Robot.new
    r2=Robot2.new
    cmds = Commands.randomCommandsInput
    rep1 = r1.executeCommands(cmds)
    rep2 = r2.executeCommands(cmds)
    assert_equal(rep1,rep2)
  end
  def testRobotsAgainstEachOtherForManyRandomCommandsDifferentEachTime
    srand(Time.now.to_i)
    r1= Robot.new
    r2=Robot2.new
    numberOfReports=0
    numberOfRuns = 1000
    (1..numberOfRuns).each {
        cmds = Commands.randomCommandsInput
        cmds
        rep1 = r1.executeCommands(cmds)
        rep2 = r2.executeCommands(cmds)
        numberOfReports=numberOfReports+rep2.size
        assert_equal(rep1,rep2)

    }
    assert_equal(numberOfReports>(numberOfRuns-4)*3,true)
  end


end


