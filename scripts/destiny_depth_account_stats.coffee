DestinyClient = require 'destinyclient'

module.exports = (robot) ->
	return console.error 'Destiny not configured! Set DESTINY_API environment variable' unless process.env.DESTINY_API
	destiny = new DestinyClient process.env.DESTINY_API

	robot.respond /show in depth (.*) stats for (.*)/i, (msg) ->
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
							response += "Precision Kills: #{stats.precisionKills.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
							response += "Deaths: #{stats.deaths.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
							response += "Assists: #{stats.assists.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
							response += "Longest Kill Spree: #{stats.longestKillSpree.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
							response += "Average Life Span: #{stats.averageLifespan.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
							response += "Most Kills in One Game: #{stats.bestSingleGameKills.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
							response += "Most Precision Kills in One Game: #{stats.mostPrecisionKills.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
							response += "Revives Performed: #{stats.resurrectionsPerformed.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
							response += "Revives Received: #{stats.resurrectionsReceived.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
							response += "Orbs Created: #{stats.orbsDropped.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
							response += "Orbs Gathered: #{stats.orbsGathered.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
							response += "Best Weapon Type: #{stats.weaponBestType.basic.displayValue}\n"
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
							response += "Precision Kills: #{stats.precisionKills.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
							response += "Deaths: #{stats.deaths.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
							response += "Assists: #{stats.assists.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
							response += "Longest Kill Spree: #{stats.longestKillSpree.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
							response += "Average Life Span: #{stats.averageLifespan.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
							response += "Most Kills in One Game: #{stats.bestSingleGameKills.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
							response += "Most Precision Kills in One Game: #{stats.mostPrecisionKills.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
							response += "Revives Performed: #{stats.resurrectionsPerformed.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
							response += "Revives Received: #{stats.resurrectionsReceived.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
							response += "Orbs Created: #{stats.orbsDropped.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
							response += "Orbs Gathered: #{stats.orbsGathered.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
							response += "Best Weapon Type: #{stats.weaponBestType.basic.displayValue}\n"
							response += "Total Time: #{stats.totalActivityDurationSeconds.basic.displayValue}\n```"
							msg.send response
