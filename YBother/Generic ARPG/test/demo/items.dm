
// File:    demo\items.dm
// Library: Forum_account.ActionRpgFramework
// Author:  Forum_account
//
// Contents:
//   This file defines items and shows how to:
//    * create items that give stat bonuses
//    * create items that can be used and consumed
//    * create stackable items
//    * create equippable items

// we define the equipment slots we'll have
var
	const
		TWO_HAND = "two-hand"
		MAIN_HAND = "main-hand"
		BODY = "body"
		HEAD = "head"
		OFF_HAND = "off-hand"
		FEET = "feet"
		HANDS = "hands"
		WRISTS = "wrists"
		SHOULDERS = "shoulders"
		AMULET = "amulet"
		LEFT_FINGER = "left-finger"
		RIGHT_FINGER = "right-finger"
		BELT = "belt"
		LEGS = "legs"
		BACK = "back"


item
	icon = 'items.dmi'
	overlay_icon = 'overlays.dmi'
	map_icon = 'items.dmi'

	CraftingItems
		iron_bar
			name = "Iron Bar"
			icon_state = "iron-bar"
			map_state = "iron-bar-map"
			cost = 5

			stack_size = 20
			count = 1
			description = "Also high in fiber."
		stick
			name = "Stick"
			icon_state = "stick"
			map_state = "stick-map"
			cost = 5

			stack_size = 20
			count = 1
			description = "Brown, and rather sticky."
		string
			name = "String"
			icon_state = "string"
			map_state = "string-map"
			cost = 5

			stack_size = 50
			count = 1
			description = "I bet cats would love this."
		ruby
			name = "Ruby"
			icon_state = "ruby"
			map_state = "ruby-map"
			cost = 5

			stack_size = 10
			count = 1
			description = "Named after your great-great aunt."
	Equipment
		equipped(mob/m)
			m.overlay(src)
			m.power += power
			m.mind += mind
			m.dexterity += dexterity
			m.agility += agility
			m.willpower += willpower
			m.strength += strength
			m.vitality += vitality
			m.defense += defense
			m.resistance += resistance
		unequipped(mob/m)
			m.remove(src)
			m.power -= power
			m.mind -= mind
			m.dexterity -= dexterity
			m.agility -= agility
			m.willpower -= willpower
			m.strength -= strength
			m.vitality -= vitality
			m.defense -= defense
			m.resistance -= resistance
		Weapons
			wand
				name = "Wand"
				style = "magic"
				icon_state = "wand"
				description = "+5 Power +2 Mind"
				overlay_state = "wand"
				overlay_layer = 2
				map_state = "wand-map"
				cost = 10
				power = 5

				slot = MAIN_HAND



			wizard_wand
				name = "Wizard Wand"
				style = "magic"
				icon_state = "wizard_wand"
				description = "+15 Power +5 Mind"
				overlay_state = "wand"
				overlay_layer = 2
				map_state = "wizard-wand-map"
				cost = 50
				power = 15

				slot = MAIN_HAND

			bow
				name = "Bow"
				icon_state = "bow"
				style = "bow"
				description = "+10 Power +3 Dexterity"
				overlay_state = "bow"
				overlay_layer = 2
				map_state = "bow-map"
				cost = 20
				power = 10
				dexterity = 3
				slot = TWO_HAND
			elf_bow
				name = "Elvish Bow"
				icon_state = "elf_bow"
				style = "bow"
				description = "+25 Power +7 Dexterity"
				overlay_state = "bow"
				overlay_layer = 2
				map_state = "elf-bow-map"
				cost = 90
				power = 25
				dexterity = 7
				slot = TWO_HAND

			sword
				name = "Sword"
				icon_state = "sword"
				style = "melee"
				description = "+5 Power +2 Strength"
				overlay_state = "sword"
				overlay_layer = 2
				map_state = "sword-map"
				cost = 10
				power = 5
				strength = 2
				slot = MAIN_HAND

			large_sword
				name = "Large Sword"
				icon_state = "large_sword"
				style = "melee"
				description = "+15 Power +5 Strength"
				overlay_state = "sword"
				overlay_layer = 2
				map_state = "large-sword-map"
				cost = 50
				power = 15
				strength = 5
				slot = MAIN_HAND

			dagger
				name = "Dagger"
				icon_state = "dagger"
				style = "melee"
				description = "+3 Power, +1 Dexterity, +1 Agility"
				overlay_state = "dagger"
				overlay_layer = 2
				map_state = "dagger-map"
				cost = 10
				power = 3
				dexterity = 1
				agility = 1
		Armor
			shield
				name = "Shield"
				icon_state = "shield"
				description = "+5 Defense"
				overlay_state = "shield"
				overlay_layer = 2
				map_state = "shield-map"
				cost = 15
				defense = 5

			helmet
				name = "Helmet"
				icon_state = "helmet"
				description = "+2 Defense"
				overlay_state = "helmet"
				map_state = "helmet-map"
				defense = 2
				slot = HEAD
				cost = 5

			armor
				name = "Armor"
				icon_state = "armor"
				description = "+4 Defense"
				overlay_state = "armor"
				map_state = "armor-map"
				defense = 4
				slot = BODY
				cost = 15

	Potions
		var
			restore
		Health_Potions
			use(mob/m)
				m.gain_health(restore)
				// consume one potion
				consume(1)
				usr.ability_bar.refresh()
			health_potion
				name = "Health Potion"
				icon_state = "small-health-potion"
				description = "Restores 15 health"
				map_state = "small-health-potion-map"
				style = "potion"
				count = 1
				stack_size = 5
				cost = 5
				restore = 15

			large_health_potion
				name = "Large Health Potion"
				icon_state = "health-potion"
				description = "Restores 50 health"
				map_state = "health-potion-map"
				style = "potion"

				count = 1
				stack_size = 5
				cost = 5
				restore = 50

		Mana_Potions
			use(mob/m)
				m.gain_mana(restore)
				// consume one potion
				consume(1)
				usr.ability_bar.refresh()
			mana_potion
				name = "Mana Potion"
				icon_state = "small-mana-potion"
				description = "Restores 15 mana"
				map_state = "small-mana-potion-map"
				style = "potion"
				count = 1
				stack_size = 5
				cost = 5
				restore = 15

			large_mana_potion
				name = "Large Mana Potion"
				icon_state = "mana-potion"
				description = "Restores 50 mana"
				map_state = "mana-potion-map"
				style = "potion"
				count = 1
				stack_size = 5
				cost = 5
				restore = 50


mob
	// we play this sound effect when a player loots or buys an item
	got_item()
		..()
		sound_effect('boop.wav')
		if(ability_bar)
			ability_bar.refresh()
