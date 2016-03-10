# Description:
#   Action alias for hubot
#
# Commands:
#   hubot show my guardians
#

DestinyClient = require 'destinyclient'

module.exports = (robot) ->
  return console.error 'Destiny not configured! Set DESTINY_API environment variable' unless process.env.DESTINY_API
  destiny = new DestinyClient process.env.DESTINY_API

  robot.respond /show my guardians/, (msg) ->
    destiny.searchDestinyPlayer msg.message.user.id.username, (err, players) ->
      for player in players
        destiny.getAccountSummary player.membershipType, player.membershipId, (err, accountSummary) ->
          for character in accountSummary.data.characters
            msg.send "https://www.bungie.net#{character.emblemPath}"
