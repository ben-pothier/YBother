
// File:    hud-info.dm
// Library: Forum_account.ActionRpgFramework
// Author:  Forum_account
//
// Contents:
//   This file defines the HUD object for the info box,
//   which displays the player's level, money, and
//   experience.

InfoBox
	parent_type = /HudBox

	var
		HudObject/title
		HudObject/money
		HudObject/experience
		HudObject/power
		HudObject/speed
		HudObject/strength
		HudObject/vitality
		HudObject/agility
		HudObject/dexterity
		HudObject/defense
		HudObject/resistance
		HudObject/mind
		HudObject/willpower
		HudObject/crafting
		HudObject/separator
		HudObject/separator1
		current_height = 0
	New(mob/m)
		..(m)

		box(4, 6)

		owner = m

		// display your level, class, money, and experience
		current_height = height*29
		title = add(12, current_height, maptext_width = width * 32 - 24, layer = layer + 1)
		calc_height_item()
		crafting = add(12, current_height, maptext_width = width * 32 - 24, layer = layer + 1)
		calc_height_separator()
		separator = add(12,current_height, maptext_width = width * 32 - 24, layer = layer +1)
		calc_height_itemAfterSeparator()
		money = add(12, current_height, maptext_width = width * 32 - 24, layer = layer + 1)
		calc_height_item()
		experience = add(12, current_height, maptext_width = width * 32 - 24, layer = layer + 1)
		calc_height_separator()
		separator1 = add(12,current_height, maptext_width = width * 32 - 24, layer = layer +1)
		calc_height_itemAfterSeparator()
		power = add(12, current_height, maptext_width = width * 32 - 24, layer = layer + 1)
		calc_height_item()
		speed = add(12, current_height, maptext_width = width * 32 - 24, layer = layer + 1)
		calc_height_item()
		strength = add(12, current_height, maptext_width = width * 32 - 24, layer = layer + 1)
		calc_height_item()
		vitality = add(12, current_height, maptext_width = width * 32 - 24, layer = layer + 1)
		calc_height_item()
		agility = add(12, current_height, maptext_width = width * 32 - 24, layer = layer + 1)
		calc_height_item()
		dexterity = add(12, current_height, maptext_width = width * 32 - 24, layer = layer + 1)
		calc_height_item()
		defense = add(12, current_height, maptext_width = width * 32 - 24, layer = layer + 1)
		calc_height_item()
		resistance = add(12, current_height, maptext_width = width * 32 - 24, layer = layer + 1)
		calc_height_item()
		mind = add(12, current_height, maptext_width = width * 32 - 24, layer = layer + 1)
		calc_height_item()
		willpower = add(12, current_height, maptext_width = width * 32 - 24, layer = layer + 1)

		refresh()

		pos(Constants.VIEW_WIDTH * Constants.ICON_WIDTH - 128 - 16, 16)

	proc
		calc_height_item()
			current_height -= 12
		calc_height_separator()
			current_height -= 8
		calc_height_itemAfterSeparator()
			current_height -= 9
		refresh()
			title.maptext = "<b>[owner.description()]</b>"
			crafting.maptext = "<i>[owner.crafting_class]</i>"
			separator.maptext = "<b>--------------------------</b>"
			money.maptext = "Money: $[owner.money]"
			experience.maptext = "XP: [owner.experience] / [owner.experience_needed]"
			separator1.maptext = "<b>--------------------------</b>"
			power.maptext = "Power: [owner.power]"
			speed.maptext = "Speed: [owner.speed]"
			strength.maptext = "Strength: [owner.strength]"
			vitality.maptext = "Vitality: [owner.vitality]"
			agility.maptext = "Agility: [owner.agility]"
			dexterity.maptext = "Dexterity: [owner.dexterity]"
			defense.maptext = "Defense: [owner.defense]"
			resistance.maptext = "Resistance: [owner.resistance]"
			mind.maptext = "Mind: [owner.mind]"
			willpower.maptext = "Willpower: [owner.willpower]"


mob
	var
		tmp/InfoBox/info_box
		tmp/last_move_time = 0

	movement()
		..()

		if(info_box)
			if(moved)
				last_move_time = world.time

			if(world.time > last_move_time + Constants.INFO_BOX_DELAY)
				info_box.show()
			else
				info_box.hide()

	init_hud()
		..()

		if(client && Constants.USE_INFO_BOX)
			info_box = new(src)

	clear_hud()
		..()

		if(Constants.USE_INFO_BOX)
			if(info_box)
				info_box.hide()
				del info_box
