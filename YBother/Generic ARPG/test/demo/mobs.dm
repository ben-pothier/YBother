
// File:    demo\mobs.dm
// Library: Forum_account.ActionRpgFramework
// Author:  Forum_account
//
// Contents:
//   This file initializes the player's mob and gives
//   them some items and abilities.

#define DEBUG

world
	map_format = SIDE_MAP

// Uncomment this line to change the title screen image.
// Options/title_screen = 'title-screen.png'

HealthMeter
	show_caption = 1
ManaMeter
	show_caption = 1
XPMeter
	show_caption = 1

AbilityMenu
	size = 5

mob
	icon = 'mobs.dmi'
	base_state = "human"
	pwidth = 16
	pheight = 16
	pixel_x = -8


	var

		class = ""
		base_speed = 6
		power = 10
		mind = 0
		defense = 0
		resistance = 0
		agility = 0
		willpower = 0
		strength = 0
		dexterity = 0
		vitality = 0
		original_locx = 0
		original_locy = 0
		original_locz = 0
		num_slots = 6
		tmp/slowed = 0
		tmp/paralyzed = 0
		tmp/kamehd = 0

		tmp/Overlay/weapon
		tmp/Overlay/armor

	description(full_description = 0)
		if(full_description)
			return "<b>[name]</b>\nLevel [plevel] [class]"
		else
			return "Level [plevel] [class]"
	health_regen()
		gain_health(round(vitality/10))
	mana_regen()
		gain_mana(round(willpower/5))

	new_character()
		loc = null

		src << "Welcome to the Action RPG Framework Sample Game!"
		src << ""
		src << "Press \[I] to open your inventory."
		src << "Press \[A] to customize your abilities."
		src << "Press \[Space Bar] to interact with NPCs."
		src << "Press \[Esc] to exit menus, close windows, or bring up the game menu."
		src << "Press \[L] or \[Space Bar] to loot corpses."
		src << "Press \[1] and \[2] to attack."
		src << "Press \[Tab] to select a hostile target."
		src << "Press \[Shift] + \[Tab] to select a friendly target."
		src << "Press \[Q] to switch input focus to the quest tracker."
		src << "Press \[H] to switch input focus to the info bar."

		name = text_prompt("What is your name?")
		team = prompt("What team are you on?", "North","South")
		if(team == "South")
			team = Constants.TEAM_SOUTH
		else
			team = Constants.TEAM_NORTH
		class = "Beginner"
		if(team == Constants.TEAM_SOUTH)
			loc = locate(99,25,1)
		else
			loc = locate(99,175,1)
		camera.pixel_x = 24
		src.MapColor=rgb(255,255,255)
		// give the player some money
		set_money(20)

		//get_item(new /item/Equipment/Armor/armor())



		// give the player some attacks
		abilities += new /Ability/Attack()
		abilities += new /Ability/Cleave()
		abilities += new /Ability/Poison()
		abilities += new /Ability/Fireball()
		mind = 4
		defense = 4
		resistance = 4
		agility = 4
		willpower = 4
		strength = 4
		dexterity = 4
		vitality = 4
		max_health = 10
		max_mana = 10
		health = max_health
		mana = max_mana
		get_item(new /item/Potions/Health_Potions/health_potion())
		get_item(new /item/Potions/Health_Potions/health_potion())
		get_item(new /item/Potions/Health_Potions/health_potion())
		get_item(new /item/Potions/Health_Potions/health_potion())
		get_item(new /item/Potions/Health_Potions/health_potion())
		get_item(new /item/Equipment/Weapons/sword())
		get_item(new /item/Potions/Mana_Potions/mana_potion())
		get_item(new /item/Potions/Mana_Potions/mana_potion())
		get_item(new /item/Potions/Mana_Potions/mana_potion())
		get_item(new /item/Potions/Mana_Potions/mana_potion())
		get_item(new /item/Potions/Mana_Potions/mana_potion())
		get_item(new /item/Equipment/Weapons/wand())
		get_item(new /item/Equipment/Weapons/bow())
		if(info_box)
			info_box.refresh()
		health_meter.update()
		mana_meter.update()
		xp_meter.update()
		// Bind MeleeAttack and Cleave to the 1 and 2 keys.
		// The on-screen ability bar will automatically be
		// updated to show these key bindings.
		if(ability_bar)
			ability_bar.refresh()
		my_custom_hud = new(src)
		for(var/MapObj/o in client.maps)
			o.Scan()


	Login()
		..()
		music('music.xm')
		for(var/MapObj/o in client.maps)
			o.Scan()

	action()
		if(slowed)
			move_speed = base_speed * 0.5
		else
			move_speed = base_speed
		if(paralyzed)
			move_speed = 0
		else
			move_speed = base_speed

		..()

	died()
		..()

		// when a player dies, make them wait two seconds and respawn.
		if(client)
			src << "You died! You'll respawn in two seconds."

			spawn(20)
				respawn()
				for(var/MapObj/o in client.maps)
					o.Scan()

	// after the player respawns, move them back to the starting location
	respawned(mob/m)
		..()
		if(client)
			if(team == Constants.TEAM_SOUTH)
				loc = locate(99, 25, 1)
			else
				loc = locate(99,175,1)
			for(var/MapObj/o in client.maps)
				o.Scan()
mob
	var
		shadow_state = "shadow"

	// regular mobs have shadows
	Read()
		..()
		underlays = null
		underlays += image(icon, icon_state = shadow_state, layer = layer - 0.5)

	New()
		..()
		underlays = null
		underlays += image(icon, icon_state = shadow_state, layer = layer - 0.5)

// you can click on mobs to add or remove them from your party.


		/**
		if(m == usr)
			usr.create_party()
			return

		if(istype(m))
			if(!usr.party)
				usr.party = new(usr)

			if(m in usr.party.mobs)
				usr.party.remove_player(m)
				usr << "You have removed [m] from your party!"
				m << "You been removed from [usr]'s party!"
			else
				usr.party.add_player(m)
				usr << "You have added [m] to your party!"
				m << "You have been added to [usr]'s party!"

		if(o.icon_state == "stone-01")
			flick("lowering",o)
			o.icon_state="down"
			o.density = 0
		else
			o.density = 1
			flick("raising",o)
			o.icon_state="stone-01"
		**/

