
// File:    demo\custom-hud.dm
// Library: Forum_account.ActionRpgFramework
// Author:  Forum_account
//
// Contents:
//   This file shows how to use the /HudBox object to
//   create a custom interface.

MyCustomHud
	parent_type = /HudBox

	var
		HudListBox/list_box
		HudObject/title
		HudObject/xp_caption
		slot_width
		slot_height
		slots_size = "4x3"
		HudObject/caption
		HudObject/caption1
		HudObject/caption2
		HudObject/caption3
		HudObject/caption4

	New()
		..()
		// create a 5x5 panel as the background
		panel(5, 5)

		// create a 4x3 list box
		list_box = list_box(4, 3)
		list_box.pos(16, 16)

		// center the interface
		pos(176, 112)
		var/list/parts = split(slots_size, "x")
		slot_width = text2num(parts[1])
		slot_height = text2num(parts[2])
		title = add(0, slot_height * Constants.ICON_HEIGHT + 40, maptext = "<text align=center><b>[title]</b></text>", maptext_width = (slot_width + 1) * Constants.ICON_WIDTH, layer = layer + 2)
		xp_caption = add(0,slot_height * Constants.ICON_HEIGHT + 24, maptext = "<text align=center><b>[xp_caption]</b></text>", maptext_width = (slot_width + 1) * Constants.ICON_WIDTH, layer = layer + 2)
		// make the list box show your abilities
		list_box.displayCrafting(owner.abilities)
		//title.maptext = "<text align=center><b>Level: [owner.crafting_level]</b></text>"
		//xp_caption.maptext = "<text align=center><b>Crafting Exp: </b>[owner.crafting_xp] / [owner.crafting_xp_needed]</text>"
		caption = add(0, 0, "", maptext_width = 160, maptext_height = 64, layer = layer + 2)
		caption1 = add(0, 0, "", maptext_width = 160, maptext_height = 64, layer = layer + 1)
		caption2 = add(0, 0, "", maptext_width = 160, maptext_height = 64, layer = layer + 1)
		caption3 = add(0, 0, "", maptext_width = 160, maptext_height = 64, layer = layer + 1)
		caption4 = add(0, 0, "", maptext_width = 160, maptext_height = 64, layer = layer + 1)

		// hide this interface by default
		hide()

	key_down(k)
		..()

		if(k == Constants.KEY_CANCEL)
			close()

	// when you close it, we hide the interface and
	// restore focus to the owner
	close()
		hide()
		owner.client.focus = owner
	proc
		show_caption(i)
			var/HudObject/o = i
			var/Ability/ability = o.value
			caption.pos(o.sx + 36, o.sy + 2)
			if(ability && istype(ability))
				caption.maptext = ability.description()
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
		update()
			//title.maptext = "<text align=center><b>Level: [owner.crafting_level]</b></text>"
			//xp_caption.maptext = "<text align=center><b>Crafting Exp: </b>[owner.crafting_xp] / [owner.crafting_xp_needed]</text>"
mob
	var
		MyCustomHud/my_custom_hud

	init_hud()
		..()
		my_custom_hud = new(src)

