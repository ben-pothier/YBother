
// File:    demo\crafting.dm
// Library: Forum_account.ActionRpgFramework
// Author:  Forum_account
//
// Contents:
//   This file shows how to define a crafting ability.
//   They inherit from the Ability object but they have
//   some additional variables that make them appropriate
//   for creating crafting abilities.

obj
	CraftingObjects
		interact()
			usr.client.focus = usr.my_custom_hud
			usr.my_custom_hud.show()
		anvil
			icon = 'turfs.dmi'
			icon_state = "anvil"
			density = 1
		arcaneForge
			icon = 'turfs.dmi'
			icon_state = "arcaneForge"
			density = 1
		carpenterTable
			icon = 'turfs.dmi'
			icon_state = "carpTable"
			density = 1
	fake_wall
		icon = 'walls.dmi'
		icon_state = "stone-01"
		density = 1
		var/raised = 1
		var/moving = 0

	objswitch
		icon = 'items.dmi'
		icon_state = "switch-off"
		interact()
			if(src.icon_state == "switch-off")
				src.icon_state = "switch-on"
				for(var/obj/fake_wall/f in oview(3))
					if(f.icon_state == "stone-01" && f.moving == 0)
						flick("lowering",f)
						f.icon_state="down"
						f.moving = 1
						spawn(20)
							f.density = 0
							f.moving = 0
						return "Flicked a switch"
					else if(f.icon_state == "down" && f.moving == 0)
						f.density = 1
						flick("raising",f)
						f.icon_state="stone-01"
						f.moving = 1
						spawn(20)
							f.moving = 0
						return "Flicked a switch"
			else
				src.icon_state = "switch-off"
				for(var/obj/fake_wall/f in oview(3))
					if(f.icon_state == "down" && f.moving == 0)
						f.density = 1
						flick("raising",f)
						f.icon_state="stone-01"
						f.moving = 1
						spawn(20)
							f.moving = 0
						return "Flicked a switch"
					else if(f.icon_state == "stone-01" && f.moving == 0)
						flick("lowering",f)
						f.icon_state="down"
						f.moving = 1
						spawn(20)
							f.density = 0
							f.moving = 0
						return "Flicked a switch"

// crafting abilities consume items in the player's
// inventory and create a new item. here's an example:
CraftingAbility
	Blacksmithing
		MakeLargeSword
			name = "Make Large Sword"
			icon_state = "ability-button-make-sword"

		// this requires 4 iron bars and it requires that
		// the player be near an anvil
			materials = list(/item/CraftingItems/iron_bar = 8)
			required_object = /obj/CraftingObjects/anvil

		// it turns the iron bars into a large sword
			product = /item/Equipment/Weapons/large_sword

		MakeShield
			name = "Make Shield"
			icon_state = "ability-button-make-shield"

		// this requires 4 iron bars and it requires that
		// the player be near an anvil
			materials = list(/item/CraftingItems/iron_bar = 8)
			required_object = /obj/CraftingObjects/anvil

		// it turns the iron bars into a sword
			product = /item/Equipment/Armor/shield
		MakeHelmet
			name = "Make Helmet"
			icon_state = "ability-button-make-helmet"

		// this requires 4 iron bars and it requires that
		// the player be near an anvil
			materials = list(/item/CraftingItems/iron_bar = 3)
			required_object = /obj/CraftingObjects/anvil

		// it turns the iron bars into a sword
			product = /item/Equipment/Armor/helmet
		MakeArmor
			name = "Make Armor"
			icon_state = "ability-button-make-armor"

		// this requires 4 iron bars and it requires that
		// the player be near an anvil
			materials = list(/item/CraftingItems/iron_bar = 10)
			required_object = /obj/CraftingObjects/anvil
		// it turns the iron bars into a sword
			product = /item/Equipment/Armor/armor
/**
		MakeGauntlets
			name = "Make Gauntlets"
			icon_state = "ability-button-make-gauntlets"

		// this requires 4 iron bars and it requires that
		// the player be near an anvil
			materials = list(/item/CraftingItems/iron_bar = 5)
		required_object = /obj/anvil

			// it turns the iron bars into a sword
			product = /item/gauntlets

		MakeGreaves
			name = "Make Greaves"
			icon_state = "ability-button-make-greaves"


			materials = list(/item/CraftingItems/iron_bar = 4)
			required_object = /obj/CraftingObjects/anvil

			product = /item/Equipment/Weapons/bow
**/
	Wizardy
		MakeWand
			name = "Make Wand"
			icon_state = "ability-button-make-wand"


			materials = list(/item/CraftingItems/iron_bar = 2, /item/CraftingItems/ruby = 1)
			required_object = /obj/CraftingObjects/arcaneForge
			product = /item/Equipment/Weapons/wand
/**
	MakeRobe
		name = "Make Robe"
		icon_state = "ability-button-make-robe"


		materials = list(/item/CraftingItems/iron_bar = 2, /item/CraftingItems/ruby = 1)
		required_object = /obj/CraftingObjects/arcaneForge
		product = /item/Equipment/Weapons/wand
**/
	Boywer
		MakeBow
			name = "Make Bow"
			icon_state = "ability-button-make-bow"

			materials = list(/item/CraftingItems/stick = 2, /item/CraftingItems/string = 1)
			required_object = /obj/CraftingObjects/carpenterTable
			product = /item/Equipment/Weapons/bow
/**
		MakeQuiver
			name = "Make Quiver"
			icon_state = "ability-button-make-quiver"
			materials = list(/item/CraftingItems/stick = 5, /item/CraftingItems/string = 2, /item/leather = 1)
			required_object = /obj/CraftingObjects/carpenterTable
			product = /item/quiver

	Botany
		MakeHPotion
			name = "Make Health Potion"
			icon_state = "ability-button-make-health-potion"
			materials = list(/item/herbs = 2, /item/glass_bottle = 1)
			required_object = /obj/CraftingObjects/pestle
			product = /item/Potions/Health_Potions/health_potion
		MakeMPotion
			name = "Make Mana Potion"
			icon_state = "ability-button-make-mana-potion"
			materials = list(/item/herbs = 2, /item/glass_bottle = 1)
			required_object = /obj/CraftingObjets/pestle
			product = /item/Potions/Mana_Potions/mana_potion
		MakeLHPotion
			name = "Make Large Health Potion"
			icon_state = "ability-button-make-large-health-potion"
			materials = list(/item/herbs = 5, /item/large_glass_bottle = 1)
			required_object = /obj/CraftingObjects/pestle
			product = /item/Potions/Health_Potions/health_potion
		MakeLMPotion
			name = "Make Mana Potion"
			icon_state = "ability-button-make-large-mana-potion"
			materials = list(/item/herbs = 5, /item/large_glass_bottle = 1)
			required_object = /obj/CraftingObjets/pestle
			product = /item/Potions/Mana_Potions/mana_potion
	GlassBlowing
		MakeBottle
			name = "Make Bottle"
			icon_state = "ability-button-make-bottle"
			materials = list(/item/sand = 2)
			required_object = /obj/CraftingObjects/forge
			product = /item/glass_bottle
		MakeLargeBottle
			name = "Make Large Bottle"
			icon_state = "ability-button-make-large-bottle"
			materials = list(/item/sand = 5)
			required_object = /obj/CraftingObjects/forge
			product = /item/large_glass_bottle
	Leatherworking
		MakeLeather
			name = "Make Leather"
			icon_state = "ability-button-make-leather"
			materials = list(/item/hide = 2)
			required_object = /obj/CraftingObjects/tanning_rack
			product = /item/leather
**/