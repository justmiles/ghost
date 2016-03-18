
DestinyClient = require 'destinyclient'

module.exports = (robot) ->
	return console.error 'Destiny not configured! Set DESTINY_API environment variable' unless process.env.DESTINY_API
	destiny = new DestinyClient process.env.DESTINY_API

	robot.respond /show (.*) weapon breakdown (.*) stats for (.*)/i, (msg) ->
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
											response = "```#{name}'s #{classRequest} weapon breakdown for #{activity}: \n"
											response += "Enemies Killed: #{stats.kills.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
											response += "Ability: #{stats.abilityKills.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
											response += "Super: #{stats.weaponKillsSuper.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
											response += "Grenade: #{stats.weaponKillsGrenade.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
											response += "Melee: #{stats.weaponKillsMelee.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
											response += "Precision Kills: #{stats.precisionKills.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
											response += "Assault Rifle: #{stats.weaponKillsAutoRifle.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
											response += "Pulse Rifle: #{stats.weaponKillsPulseRifle.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
											response += "Scout Rifle: #{stats.weaponKillsScoutRifle.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
											response += "Hand Cannon: #{stats.weaponKillsHandCannon.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
											response += "Fusion Rifle: #{stats.weaponKillsFusionRifle.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
											response += "Shotgun: #{stats.weaponKillsShotgun.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
											response += "Sidearm: #{stats.weaponKillsSideArm.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
											response += "Sniper: #{stats.weaponKillsSniper.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
											response += "Heavy Machine Gun: #{stats.weaponKillsMachinegun.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
											response += "Rocket Launcher: #{stats.weaponKillsRocketLauncher.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
											response += "Sword: #{stats.weaponKillsSword.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
											response += "Best Weapon: #{stats.weaponBestType.basic.displayValue}\n"
											response += "```"
											msg.send response
							else
								destiny.getCharacterStats player.membershipType, player.membershipId, characterInfo.characterId, (err, characterStats) ->
									if characterStats[apiActivity] == undefined
										msg.send "Cannot retrieve stats for #{activity}."
									stats = characterStats[apiActivity].allTime
									response = "```#{name}'s #{classRequest} weapon breakdown for #{activity}: \n"
									response += "Enemies Killed: #{stats.kills.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
									response += "Ability: #{stats.abilityKills.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
									response += "Super: #{stats.weaponKillsSuper.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
									response += "Grenade: #{stats.weaponKillsGrenade.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
									response += "Melee: #{stats.weaponKillsMelee.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
									response += "Precision Kills: #{stats.precisionKills.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
									response += "Assault Rifle: #{stats.weaponKillsAutoRifle.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
									response += "Pulse Rifle: #{stats.weaponKillsPulseRifle.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
									response += "Scout Rifle: #{stats.weaponKillsScoutRifle.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
									response += "Hand Cannon: #{stats.weaponKillsHandCannon.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
									response += "Fusion Rifle: #{stats.weaponKillsFusionRifle.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
									response += "Shotgun: #{stats.weaponKillsShotgun.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
									response += "Sidearm: #{stats.weaponKillsSideArm.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
									response += "Sniper: #{stats.weaponKillsSniper.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
									response += "Heavy Machine Gun: #{stats.weaponKillsMachinegun.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
									response += "Rocket Launcher: #{stats.weaponKillsRocketLauncher.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
									response += "Sword: #{stats.weaponKillsSword.basic.displayValue.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}\n"
									response += "Best Weapon: #{stats.weaponBestType.basic.displayValue}\n"
									response += "```"
									msg.send response
					if characterNotFound
						msg.send "Could not find character."

