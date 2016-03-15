# Description:
#   Action alias for hubot
#
# Commands:
#   hubot show (gamertag|my) guardians
#

DestinyClient = require 'destinyclient'

module.exports = (robot) ->
  return console.error 'Destiny not configured! Set DESTINY_API environment variable' unless process.env.DESTINY_API
  destiny = new DestinyClient process.env.DESTINY_API

  robot.respond /show (.*) guardians/i, (msg) ->
    displayName = escape(msg.match[1])
    if displayName == 'my'
      displayName = msg.message.user.name
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