# Description:
#   Action alias for hubot
#
# Commands:
#   hubot show (gamertag|my) guardians
#   hubot set destiny account to (name)
#
DestinyClient = require 'destinyclient'

class HubotDestinyClient extends DestinyClient

  setRobot: (robot) ->
    @robot = robot

  getHubotUser: (msg) ->
    user = @robot.brain.userForName msg.message.user.name
    user.destiny or= {}
    return user.destiny

module.exports = (robot) ->

  return console.error 'Destiny not configured! Set DESTINY_API environment variable' unless process.env.DESTINY_API
  destiny = new HubotDestinyClient process.env.DESTINY_API
  destiny.setRobot robot

  robot.respond /show (.*) guardians/i, (msg) ->
    user = destiny.getHubotUser(msg)
    displayName = escape(msg.match[1])

    if displayName == 'my'
      displayName = user.playerName or msg.message.user.name

    destiny.searchDestinyPlayer displayName, (err, players) ->
      if players[0] == undefined
        msg.send "No guardians found for #{displayName}"
      for player in players
        destiny.getAccountSummary player.membershipType, player.membershipId, (err, accountSummary) ->
          name = unescape(displayName)
          destinyClasses = accountSummary.definitions.classes
          response = "```#{name}'s Guardians:\n"
          for character in accountSummary.data.characters
            characterInfo = character.characterBase
            destinyClass = destinyClasses[characterInfo.classHash]
            if destinyClass != null
              response = response + "#{destinyClass.className} - #{characterInfo.powerLevel}\n"
          response = response + "```"
          msg.send response

  robot.respond /set destiny account to (.*)/i, (msg) ->
    user = destiny.getHubotUser(msg)
    user.playerName = msg.match[1]
    msg.reply "We've set your account name to #{user.playerName}"
