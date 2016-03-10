path          = require 'path'
Robot         = require 'hubot/src/robot'
{TextMessage} = require 'hubot/src/message'
assert        = require 'assert'

beforeEach 'Create Ghost', (done) ->
  GLOBAL.robot = new Robot(null, "mock-adapter", false, "ghost")

  robot.adapter.on 'connected', ->
    GLOBAL.user = GLOBAL.robot.brain.userForId '1',
      name: 'mocha'
      room: '#mocha'

    GLOBAL.adapter = robot.adapter
    done()

  robot.run()

afterEach ->
  robot.shutdown()
