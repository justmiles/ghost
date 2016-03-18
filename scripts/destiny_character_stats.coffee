# Description:
#   Action alias for hubot
#
# Commands:
#   hubot show (class) (summary|in depth|weapon breakdown) (pvp|pve|raid|strike|story|patrol) stats for (gamertag|me)
#

DestinyClient = require 'destinyclient'

module.exports = (robot) ->
	return console.error 'Destiny not configured! Set DESTINY_API environment variable' unless process.env.DESTINY_API
	destiny = new DestinyClient process.env.DESTINY_API

	robot.respond /show (.*) summary (.*) stats for (.*)/i, (msg) ->
		classRequest = msg.match[1]

		activity = msg.match[2]

		if activity == 'pve'
			apiActivity = 'allPvE'
		else if activity == 'pvp'
			apiActivity = 'allPvP'
		else if activity == 'strike'
			apiActivity = 'allStrikes'
		else
			apiActivity = activity

		name = msg.match[3]
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
							if apiActivity == 'allPvE'
								destiny.getAccountStats player.membershipType, player.membershipId, (err, accountStats) ->
									characters = accountStats.characters
									for character in characters
										if character.characterId == characterInfo.characterId
											if character.results[apiActivity] == undefined
												msg.send "Cannot retrieve stats for #{activity}."
											stats = character.results[apiActivity].allTime
											response = "```#{name}'s #{classRequest} #{activity} stats: \n"
											response += "Activities Cleared: #{stats.activitiesCleared.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
											response += "K/D: #{stats.killsDeathsRatio.basic.displayValue}\n"
											response += "K/D/A: #{stats.killsDeathsAssists.basic.displayValue}\n"
											response += "Enemies Killed: #{stats.kills.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
											response += "Total Time: #{stats.totalActivityDurationSeconds.basic.displayValue}\n```"
											msg.send response
							else
								destiny.getCharacterStats player.membershipType, player.membershipId, characterInfo.characterId, (err, characterStats) ->
									if characterStats[apiActivity] == undefined
										msg.send "Cannot retrieve stats for #{activity}."
									stats = characterStats[apiActivity].allTime
									response = "```#{name}'s #{classRequest} #{activity} stats: \n"
									if apiActivity == 'allPvP'
									 	response += "Win/Loss: #{stats.winLossRatio.basic.displayValue}\n"
									else if apiActivity == 'patrol'
										response += "Public Events Completed: #{stats.publicEventsCompleted.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
									else 
										response += "Activities Cleared: #{stats.activitiesCleared.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
									response += "K/D: #{stats.killsDeathsRatio.basic.displayValue}\n"
									response += "K/D/A: #{stats.killsDeathsAssists.basic.displayValue}\n"
									response += "Enemies Killed: #{stats.kills.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
									response += "Total Time: #{stats.totalActivityDurationSeconds.basic.displayValue}\n```"
									msg.send response
					if characterNotFound
						msg.send "Could not find character."

