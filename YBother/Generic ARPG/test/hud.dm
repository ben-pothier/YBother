
// File:    hud.dm
// Library: Forum_account.ActionRpgFramework
// Author:  Forum_account
//
// Contents:
//   This file contains the base HudBox object which is
//   used to create all on-screen elements that display
//   a box.

HudGroup
	icon = Constants.HUD_ICON
	layer = Constants.HUD_LAYER
	proc
		focus()
		close()

HudBox
	parent_type = /HudGroup

	var
		width
		height
		mob/owner

	New(mob/m)
		..(m)
		owner = m

	proc
		box(width, height)
			src.width = width
			src.height = height

			// make the corners
			add(0, 0, "box-bottom-left")
			add(width * 32 - 32, 0, "box-bottom-right")
			add(width * 32 - 32, height * 32 - 32, "box-top-right")
			add(0, height * 32 - 32, "box-top-left")

			// make the left/right sides if necessary
			if(height > 2)
				add(0, 32, "box-left", height = height - 2)
				add(width * 32 - 32, 32, "box-right", height = height - 2)

			// make the top/bottom sides if necessary
			if(width > 2)
				add(32, 0, "box-bottom", width = width - 2)
				add(32, height * 32 - 32, "box-top", width = width - 2)

			// make the middle if necessary
			if(height > 2 && width > 2)
				add(32, 32, "box-middle", width = width - 2, height = height - 2)

		panel(width, height)
			var/HudPanel/hud_panel = new(owner, width, height)
			add(hud_panel)
			return hud_panel

		list_box(width, height)

			var/HudListBox/hud_list_box = new(owner, width, height)

			add(hud_list_box)

			return hud_list_box

HudPanel
	parent_type = /HudGroup

	var
		width
		height

	New(mob/m, w, h)
		..(m)

		width = w
		height = h

		// make the corners
		add(0, 0, "box-bottom-left")
		add(width * 32 - 32, 0, "box-bottom-right")
		add(width * 32 - 32, height * 32 - 32, "box-top-right")
		add(0, height * 32 - 32, "box-top-left")

		// make the left/right sides if necessary
		if(height > 2)
			add(0, 32, "box-left", height = height - 2)
			add(width * 32 - 32, 32, "box-right", height = height - 2)

		// make the top/bottom sides if necessary
		if(width > 2)
			add(32, 0, "box-bottom", width = width - 2)
			add(32, height * 32 - 32, "box-top", width = width - 2)

		// make the middle if necessary
		if(height > 2 && width > 2)
			add(32, 32, "box-middle", width = width - 2, height = height - 2)

HudListBox
	parent_type = /HudGroup

	var
		width
		height
		mob/owner
		list/slots = list()

	New(mob/m, w, h)
		..(m)
		owner = m

		width = w
		height = h

		for(var/y = h to 1 step -1)
			for(var/x = 1 to w)
				slots += add(Constants.ICON_WIDTH * (x - 1), Constants.ICON_HEIGHT * (y - 1), "inventory-slot", layer = layer + 1)
	proc
		display(list/l)

			for(var/i = 1 to slots.len)

				var/HudObject/slot = slots[i]

				var/obj
				if(i <= l.len)
					obj = l[i]

				slot.overlays = null
				slot.value = obj

				if(istype(obj, /item))
					var/item/item = obj
					slot.overlays += icon(item.icon, item.icon_state)

				else if(istype(obj, /Ability))
					var/Ability/ability = obj
					slot.overlays += icon(ability.icon, ability.icon_state)

				else if(istype(obj, /atom))
					var/atom/atom = obj
					slot.overlays += icon(atom.icon, atom.icon_state)

				else if(istext(obj))
					slot.overlays += l[obj]
		displayCrafting(list/l)
			var j = 1
			for(var/i = 1 to slots.len)

				var/HudObject/slot = slots[j]

				var/obj
				if(i <= l.len)
					obj = l[i]

				slot.overlays = null
				if(istype(obj, /CraftingAbility))
					slot.value = obj
					var/Ability/ability = obj
					set_index_crafting(j)
					slot.overlays += icon(ability.icon, ability.icon_state)
					j+= 1
		set_index_crafting(i)
			var/HudObject/o = slots[i]
			o.belongs_to = "my_custom_hud"
			o.index = i

mob
	proc
		init_hud()
		clear_hud()
HudObject
	var
		tmp/index = 0
		tmp/belongs_to = ""

	Click()
		if(src.belongs_to == "ability-bar")
			usr.ability_menu.refresh()
			usr.ability_bar.select(index)
		if(src.belongs_to == "potion-bar")
			usr.ability_menu.refresh_potion()
			usr.ability_bar.select(index)
		else if(src.belongs_to == "ability-menu")
			usr.bind_key(usr.ability_bar.selected.value, src.value)
			usr.ability_menu.hide()
		else if(src.belongs_to == "my_custom_hud")
			usr.use_ability(src.value)
	MouseEntered()
		if(src.belongs_to == "ability-menu")
			usr.ability_menu.show_caption(src.index)
		else if(src.belongs_to == "my_custom_hud")
			usr.my_custom_hud.show_caption(src)