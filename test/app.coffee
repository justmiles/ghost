path          = require 'path'
{TextMessage} = require 'hubot/src/message'
assert        = require 'assert'
testFile      = path.basename __filename

# Test suite description
describe testFile, ->

  beforeEach ->
    # Load the file before each test
    robot.loadFile path.resolve(path.join('scripts')), testFile

  # A test
  it 'provides app info', (done) ->

    # Listen for when the adapter sends a message
    adapter.on 'send', (envelope, strings) ->
      # Assert the received message
      receivedMessage = strings[0]

      try
        assert /\d*\.\d*\.\d*/.test receivedMessage,  'Link does not match'
        done()
      catch e
        e.stack = null
        done(e)

    # Mock the adapter actually receiving the message
    adapter.receive new TextMessage(user, 'ghost whats your package version')
