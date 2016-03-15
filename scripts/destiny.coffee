# Description:
#   Action alias for hubot
#
# Commands:
#   hubot show (gamertag) guardians
#

DestinyClient = require 'destinyclient'

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
          for character in accountSummary.data.characters
            msg.send "https://www.bungie.net#{character.emblemPath}"