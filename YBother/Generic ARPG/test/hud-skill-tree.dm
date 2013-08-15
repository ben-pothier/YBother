// File:    hud-skill-tree.dm
// Library:
// Author:  Drakstone
//
// Contents:
//   This file contains the on-screen skill tree interface.


Skilltree
	parent_type = /HudBox

	var
		mob/player
		mob/skilltree
		slots = Constants.SKILLTREE_SIZE
		slot_width
		slot_height

		HudObject/cursor
		HudObject/item_description

		cursor_x = 1
		cursor_y = 1

		list/slot_objects = list()
		list/slot_captions = list()

	New(mob/m)
		..(m)

		box(5, 10)

		player = m

		// parse the inventory size
		var/list/parts = split(slots, "x")
		slot_width = text2num(parts[1])
		slot_height = text2num(parts[2])

		// create the inventory slots
		for(var/i = 1 to slot_width)
			for(var/j = 1 to slot_height)
				slot_objects += add(i * 32 - 16, j * 32, "skilltree-slot", layer = layer + 1)
				slot_captions += add(i * 32 - 16, j * 32, layer = layer + 5)

		// create the cursor
		cursor = add(0, 0, "inventory-cursor", layer = layer + 2)

		// create the caption and title
		add(16, 10, maptext = "<text align=center>Space Bar = Add skill point", maptext_width = slot_width * Constants.ICON_WIDTH, layer = layer + 2)
		add(16, slot_height * Constants.ICON_HEIGHT + 40, maptext = "<text align=center>Skilltree", maptext_width = slot_width * Constants.ICON_WIDTH, layer = layer + 2)

		item_description = add(0, 0, "", maptext_width = 128, maptext_height = 48, layer = layer + 3)

		var/left = (Constants.VIEW_WIDTH - width) * Constants.ICON_WIDTH - 16
		pos(left, 96)
		hide()

	key_down(k)
		if(k == Constants.KEY_CANCEL)
			hide()

		else if(k == Constants.KEY_UP)
			set_cursor(cursor_x, cursor_y + 1)
		else if(k == Constants.KEY_DOWN)
			set_cursor(cursor_x, cursor_y - 1)
		else if(k == Constants.KEY_RIGHT)
			set_cursor(cursor_x + 1, cursor_y)
		else if(k == Constants.KEY_LEFT)
			set_cursor(cursor_x - 1, cursor_y)

		else if(k == Constants.KEY_SELECT)

			var/item/item = current_item()

			if(item)

				owner << "That's an item."

	show(mob/m)
		skilltree = m
		refresh()
		set_cursor(1, 1)
		..()

	proc
		// update the cursor's position.
		set_cursor(cx, cy)

			if(cx < 1) cx = 1
			if(cy < 1) cy = 1
			if(cx > slot_width) cx = slot_width
			if(cy > slot_height) cy = slot_height

			cursor_x = cx
			cursor_y = cy

			cursor.pos(cursor_x * Constants.ICON_WIDTH - 16, cursor_y * Constants.ICON_HEIGHT)

			var/HudObject/slot = current_slot()
			var/item/item = slot.value

			if(item && istype(item))
				item_description.pos(slot.sx + Constants.ICON_WIDTH + 2, slot.sy)
				item_description.maptext = "[item.description()]\nCost: $[item.cost]"
			else
				item_description.maptext = ""

		// find the index based on the cursor x/y
		current_slot()

			var/index = (cursor_x - 1) * slot_height + cursor_y

			if(index < 1) return null
			if(index > slot_objects.len) return null

			// find the slot at this index
			var/HudObject/slot = slot_objects[index]

			return slot

		// find the item referenced by the current slot.
		current_item()

			var/HudObject/h = current_slot()

			if(h.value && istype(h.value, /item))
				return h.value
			else
				return null

		// update the inventory's display. this one proc handles
		// all kinds of updates whether it's an item being removed,
		// added, equipped, or unequipped.
		refresh()

			var/list/open_slots = list()
			for(var/HudObject/s in slot_objects)
				s.overlays = null
				open_slots += s

			for(var/item/i in skilltree.contents)

				if(!open_slots.len)
					break

				var/HudObject/s = open_slots[1]
				open_slots.Cut(1, 2)

				s.overlays += icon(i.icon, i.icon_state)
				s.value = i

			set_cursor(cursor_x, cursor_y)

mob
	var
		tmp/Skilltree/skilltree

	init_hud()
		..()

		if(client && Constants.USE_SKILLTREE)
			skilltree = new(src)

	clear_hud()
		..()

		if(Constants.USE_SKILLTREE)
			if(skilltree)
				skilltree.hide()
				del skilltree

	proc
		skilltree(mob/m)
			skilltree.show(m)
