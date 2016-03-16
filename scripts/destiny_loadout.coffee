# Description:
#   Action alias for hubot
#
# Commands:
#   hubot show (class) loadout for (gamertag|me)
#

DestinyClient = require 'destinyclient'

module.exports = (robot) ->
	return console.error 'Destiny not configured! Set DESTINY_API environment variable' unless process.env.DESTINY_API
	destiny = new DestinyClient process.env.DESTINY_API

	robot.respond /show (.*) loadout for (.*)/i, (msg) ->
		classRequest = msg.match[1]
		name = msg.match[2]
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
          					destiny.getCharacter player.membershipType, player.membershipId, characterInfo.characterId, (err, characterSummary) ->
          	  					characterBase = characterSummary.data.characterBase
          	  					equipmentList = characterBase.peerView.equipment
          	  					definitions = characterSummary.definitions.items
          	  					buckets = characterSummary.definitions.buckets
          	  					response = "```#{name}'s #{classRequest} - #{characterBase.powerLevel}\n"
          	  					for equipment in equipmentList
          	  						itemDef = definitions[equipment.itemHash]
          	  						itemDefBucket = itemDef.bucketTypeHash
          	  						bucketName = buckets[itemDefBucket].bucketName
          	  						if bucketName == "Subclass"
          	  							response += "Subclass: #{itemDef.itemName}\n"
          	  						else if bucketName == "Primary Weapons"
          	  							response += "Primary: #{itemDef.itemName}\n"
          	  						else if bucketName == "Special Weapons"
          	  							response += "Special: #{itemDef.itemName}\n"
          	  						else if bucketName == "Heavy Weapons"
          	  							response += "Heavy: #{itemDef.itemName}\n"
          	  						else if bucketName == "Helmet"
          	  							response += "Helmet: #{itemDef.itemName}\n"
          	  						else if bucketName == "Gauntlets"
          	  							response += "Gauntlets: #{itemDef.itemName}\n"
          	  						else if bucketName == "Chest Armor"
          	  							response += "Chest: #{itemDef.itemName}\n" 
          	  						else if bucketName == "Leg Armor"
          	  							response += "Leg: #{itemDef.itemName}\n"
          	  					response += "```"
          	  					msg.send response
          			if characterNotFound
          				msg.send "Could not find #{name}'s #{classRequest}."
