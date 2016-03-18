# Description:
#   Action alias for hubot
#
# Commands:
#   hubot show (summary|in depth|weapon breakdown) (pvp|pve|all) stats for (gamertag|me)
#

DestinyClient = require 'destinyclient'

module.exports = (robot) ->
	return console.error 'Destiny not configured! Set DESTINY_API environment variable' unless process.env.DESTINY_API
	destiny = new DestinyClient process.env.DESTINY_API

	robot.respond /show summary (.*) stats for (.*)/i, (msg) ->
		activity = msg.match[1]

		if activity == 'pve'
			apiActivity = 'allPvE'
		else if activity == 'pvp'
			apiActivity = 'allPvP'
		else if activity == 'all'
			apiActivity = 'merged'
		else
			msg.send "Could not get account stats for #{activity}."

		name = msg.match[2]
		if name == 'me'
			name = msg.message.user.name
		urlName = escape(name)

		destiny.searchDestinyPlayer urlName, (err, players) ->
			if players[0] == undefined
				msg.send "No guardians found for #{name}"
			for player in players
				destiny.getAccountSummary player.membershipType, player.membershipId, (err, accountSummary) ->
					destinyClasses = accountSummary.definitions.classes
					destiny.getAccountStats player.membershipType, player.membershipId, (err, accountStats) ->
						if apiActivity == 'merged'
							stats = accountStats.mergedAllCharacters[apiActivity].allTime
							response = "```#{name} #{activity} stats: \n"
							response += "Activities Cleared: #{stats.activitiesCleared.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
							response += "Activities Won: #{stats.activitiesWon.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
							response += "K/D: #{stats.killsDeathsRatio.basic.displayValue}\n"
							response += "K/D/A: #{stats.killsDeathsAssists.basic.displayValue}\n"
							response += "Enemies Killed: #{stats.kills.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
							response += "Total Time: #{stats.totalActivityDurationSeconds.basic.displayValue}\n```"
							msg.send response
						else
							mergedCharacters = accountStats.mergedAllCharacters.results
							if mergedCharacters == undefined
								msg.send "Problem getting stats for #{name}."
							stats = mergedCharacters[apiActivity].allTime
							response = "```#{name} #{activity} stats: \n"
							if apiActivity == 'allPvP'
							 	response += "Win/Loss: #{stats.winLossRatio.basic.displayValue}\n"
							else
								response += "Activities Cleared: #{stats.activitiesCleared.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
							response += "K/D: #{stats.killsDeathsRatio.basic.displayValue}\n"
							response += "K/D/A: #{stats.killsDeathsAssists.basic.displayValue}\n"
							response += "Enemies Killed: #{stats.kills.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
							response += "Total Time: #{stats.totalActivityDurationSeconds.basic.displayValue}\n```"
							msg.send response
