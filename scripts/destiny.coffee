# Description:
#   Action alias for hubot
#
# Commands:
#   hubot show (gamertag|my) guardians
#

DestinyClient = require 'destinyclient'
TitanHash = 3655393761
HunterHash = 671679327
WarlockHash = 2271682572

module.exports = (robot) ->
  return console.error 'Destiny not configured! Set DESTINY_API environment variable' unless process.env.DESTINY_API
  destiny = new DestinyClient process.env.DESTINY_API

  robot.respond /show (.*) guardians/i, (msg) ->
    displayName = escape(msg.match[1])
    if displayName == 'my'
      displayName = msg.message.user.id.username
    destiny.searchDestinyPlayer displayName, (err, players) ->
      if players[0] == undefined
        msg.send "No guardians found for #{displayName}"
      for player in players
        destiny.getAccountSummary player.membershipType, player.membershipId, (err, accountSummary) ->
          name = unescape(displayName)
          response = "```#{name}'s Guardians:\n"
          for character in accountSummary.data.characters
            characterInfo = character.characterBase
            if characterInfo.classHash == TitanHash
              response = response + "Titan - #{characterInfo.powerLevel}\n"
            if characterInfo.classHash == HunterHash
              response = response + "Hunter - #{characterInfo.powerLevel} \n"
            if characterInfo.classHash == WarlockHash
              response = response + "Warlock - #{characterInfo.powerLevel} \n"
          response = response + "```"
          msg.send response