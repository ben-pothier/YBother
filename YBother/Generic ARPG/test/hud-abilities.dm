
// File:    hud-abilities.dm
// Library: Forum_account.ActionRpgFramework
// Author:  Forum_account
//
// Contents:
//   This file defines the ability bar which is split
//   into the AbilityBar and AbilityMenu objects. The
//   bar shows what abilities are bound to keys, the
//   menu is used to select an ability to modify a key
//   binding.

AbilityBar
	parent_type = /HudGroup

	layer = Constants.HUD_LAYER

	var
		mob/owner
		size = 6
		index = 1
		HudObject/selected

	New(mob/m)
		..(m)

		owner = m
		size = m.num_slots
		potion_slots(owner)
		for(var/i = 3 to size)
			//var/p = i-1
			var/HudObject/o = add((i-2) * Constants.ICON_WIDTH - Constants.ICON_WIDTH, 0, "ability-button", value = "[i-2]")
			o.overlays += hud_label("<text align=center>[i-2]", layer = layer + 3, pixel_y = 22)
			o.index = i
			o.belongs_to = "ability-bar"

		pos(8, 8)
		refresh()

	proc
		potion_slots(mob/m)
			owner = m
			var/HudObject/o = add(Constants.ICON_WIDTH - Constants.ICON_WIDTH, Constants.ICON_HEIGHT + 5, "ability-button", value = "e")
			o.overlays += hud_label("<text align=center>E", layer = layer + 3, pixel_y = 22)
			o.belongs_to = "potion-bar"
			o.index = 1
			refresh()
			o = add(2*Constants.ICON_WIDTH - Constants.ICON_WIDTH, Constants.ICON_HEIGHT + 5, "ability-button", value = "r")
			o.overlays += hud_label("<text align=center>R", layer = layer + 3, pixel_y = 22)
			o.belongs_to = "potion-bar"
			o.index = 2
			refresh()
		add_slot(s, mob/m)
			owner = m
			size = s
			var/HudObject/o = add(size * Constants.ICON_WIDTH - Constants.ICON_WIDTH, 0, "ability-button", value = "[size]")
			o.overlays += hud_label("<text align=center>[size-2]", layer = layer + 3, pixel_y = 22)
			o.index = size
			o.belongs_to = "ability-bar"
			refresh()

		refresh()
		//	if(!istype(usr, /mob/temporary))
			size = owner.num_slots
			for(var/i = 1 to size)
				var/HudObject/o = objects[i]
				var/a
				if(i != 1 && i!= 2)
					a = owner.key_bindings ? owner.key_bindings["[i-2]"] : null
				else
					if(i == 1)
						a = owner.key_bindings ? owner.key_bindings["e"] : null
					else
						a = owner.key_bindings ? owner.key_bindings["r"] : null
				o.icon = Constants.HUD_ICON
				if(istype(a, /Ability))
					var/Ability/ab = a
					if(!ab)
						o.icon_state = "ability-button"
						continue
					if(ab.name == "Attack")
						ab.set_icon_state(owner,ab)
					o.icon_state = ab.icon_state
				else
					var/item/it = a
					if(o.overlays)
						o.overlays--
					if(!it)
						o.icon_state = "ability-button"
					else
						o.icon_state = "ability-button-[it.icon_state]"
						var/total
						for(var/item/Potions/pot in owner.contents)
							if(pot.type == it.type)
								total += pot.count
						o.overlays += hud_label("<text align=right>[total]", layer = layer + 3, pixel_y = 3)

	proc
		// show the ability menu
		select(index)
			selected = objects[index]
			owner.ability_menu.show(selected)

AbilityMenu
	parent_type = /HudGroup

	layer = Constants.HUD_LAYER

	var
		index = 1
		list/choices

		mob/owner
		Ability/value

		HudObject/caption
		HudObject/caption1
		HudObject/caption2
		HudObject/caption3
		HudObject/caption4


		size = 4

	New(mob/m)
		..(m)
		owner = m


		caption = add(0, 0, "", maptext_width = 160, maptext_height = 64, layer = layer + 2)
		caption1 = add(0, 0, "", maptext_width = 160, maptext_height = 64, layer = layer + 1)
		caption2 = add(0, 0, "", maptext_width = 160, maptext_height = 64, layer = layer + 1)
		caption3 = add(0, 0, "", maptext_width = 160, maptext_height = 64, layer = layer + 1)
		caption4 = add(0, 0, "", maptext_width = 160, maptext_height = 64, layer = layer + 1)

		hide()
		refresh()

	show(HudObject/o)
		pos(o.sx + owner.ability_bar.sx, o.sy + Constants.ICON_HEIGHT + owner.ability_bar.sy)
		..()
	proc
		set_index(i)
			if(i < 1) i = 1
			if(i > choices.len) i = choices.len

			index = i
			var/HudObject/o = choices[index]
			o.belongs_to = "ability-menu"
			o.index = index
		show_caption(i)
			index = i
			var/HudObject/o = choices[index]
			var/Ability/ability
			var/item/it
			if(istype(o.value, /Ability))
				ability = o.value
			else
				it = o.value
			caption.pos(o.sx + 36, o.sy + 2)

			if(ability && istype(ability))
				caption.maptext = ability.description()
			else if(it && istype(it))
				caption.maptext = it.description_potBar()
			else
				caption.maptext = "<b>No Ability</b>"

			// update the objects used to create the outline
			var/outline_text = "<font color=#000>[caption.maptext]"
			caption1.pos(caption.sx - 1, caption.sy)
			caption1.maptext = outline_text
			caption2.pos(caption.sx + 1, caption.sy)
			caption2.maptext = outline_text
			caption3.pos(caption.sx, caption.sy - 1)
			caption3.maptext = outline_text
			caption4.pos(caption.sx, caption.sy + 1)
			caption4.maptext = outline_text
			/*
			else
				caption.maptext = ""
				caption1.maptext = ""
				caption2.maptext = ""
				caption3.maptext = ""
				caption4.maptext = ""
			*/
		refresh_potion()
			for(var/atom/a in choices)
				del a

			choices = list()
			var/cx
			var/cy
			var/i = 0
			var/total_num = 1
			for(var/item/it in owner.contents)
				// filter which items are shown
				if(!show_consumable(it)) continue
				//var/HudObject/o
				//o.value = a
				//o.icon_state = a.icon_state
				//o.belongs_to = "ability-menu"
				var/test = 0
				for(var/HudObject/b in choices)
					if(cmptext("[b.value]","[it]"))
						test = 1
				if(!test)
					choices += add(cx, cy, "ability-button-[it.icon_state]", value = it)
					set_index(total_num)
					total_num += 1
					cy += Constants.ICON_HEIGHT
					i += 1
					if(i >= size)
						cx += Constants.ICON_WIDTH
						cy = 0
						i = 0


			if(i)
				cx += Constants.ICON_WIDTH
				cy = 0
			choices += add(cx, cy, "ability-button", value = null)

			set_index(total_num)
		refresh()
			for(var/atom/a in choices)
				del a

			choices = list()
			var/cx
			var/cy
			var/i = 0
			var/total_num = 1

			for(var/Ability/a in owner.abilities)
				if(a.name == "Attack")
					a.set_icon_state(owner,a)
				// filter which abilities are shown
				if(!show_ability(a)) continue
				//var/HudObject/o
				//o.value = a
				//o.icon_state = a.icon_state
				//o.belongs_to = "ability-menu"
				choices += add(cx, cy, a.icon_state, value = a)
				set_index(total_num)
				total_num += 1
				cy += Constants.ICON_HEIGHT
				i += 1

				if(i >= size)
					cx += Constants.ICON_WIDTH
					cy = 0
					i = 0
			if(i)
				cx += Constants.ICON_WIDTH
				cy = 0
			choices += add(cx, cy, "ability-button", value = null)

			set_index(total_num)

		// You can override this to create your own type of
		// filter. By default, all abilities are listed.
		show_ability(Ability/ability)
			if(ability.parent_type == /CraftingAbility)
				return 0
			return 1
		show_consumable(item/i)
			if(istype(i, /item/Potions))
				return 1

mob
	var
		tmp/AbilityBar/ability_bar
		tmp/AbilityMenu/ability_menu

	init_hud()
		..()

		if(client && Constants.USE_ABILITY_BAR)
			ability_menu = new(src)
			ability_bar = new(src)

	clear_hud()
		if(Constants.USE_ABILITY_BAR)
			if(ability_menu)
				ability_menu.hide()
				del ability_menu

			if(ability_bar)
				ability_bar.hide()
				del ability_bar

