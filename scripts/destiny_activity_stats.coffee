# Description:
#   Action alias for hubot
#
# Commands:
#   hubot show activity stats for (gamertag|me)
#

DestinyClient = require 'destinyclient'

module.exports = (robot) ->
	return console.error 'Destiny not configured! Set DESTINY_API environment variable' unless process.env.DESTINY_API
	destiny = new DestinyClient process.env.DESTINY_API

	robot.respond /show activity stats for (.*)/i, (msg) ->
		name = msg.match[1]
		if name == 'me'
      		name = msg.message.user.name
		urlName = escape(name)
		destiny.searchDestinyPlayer urlName, (err, players) ->
    		if players[0] == undefined
        		msg.send "No guardians found for #{name}"
    		for player in players
        		destiny.getAccountSummary player.membershipType, player.membershipId, (err, accountSummary) ->
        			destinyClasses = accountSummary.definitions.classes
        			characterNotFound = true
        			for character in accountSummary.data.characters
        	  			characterInfo = character.characterBase
                        destinyClass = destinyClasses[characterInfo.classHash].className
                        if destinyClass.toUpperCase() == classRequest.toUpperCase()
                            characterNotFound = false
                            destiny.getCharacterActivityStats player.membershipType, player.membershipId, characterInfo.characterId, (err, characterStats) ->
                                activities = characterStats.activities
                                definitions = characterStats.definitions.activities
                                response = "Activities: \n"
                                for activity in activities
                                    activityDef = definitions[activity.activityHash]
                                    response += "#{activityDef.activityName}\n"
                                msg.send response
                    if characterNotFound
                        msg.send "Could not find character"
