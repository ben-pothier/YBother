
// File:    template.dm
// Library: Forum_account.IconProcessor
// Author:  Forum_account
//
// Contents:
//   This file contains the Template object which can
//   be used to create a blank icon you provide as input
//   to an icon processor.

var
	Template/template = new()

Template
	var
		icon/blank = new()

		width = 32
		height = 32

	proc
		blank()
			var/icon/i = icon('icon-library.dmi', "blank")

			if(width != 32 || height != 32)
				i.Scale(width, height)

			return i

		clear()
			blank = new()

		add_state(state_name, dirs = 1, frames = 1)

			for(var/i = 1 to frames)
				if(dirs == 1)
					blank.Insert(blank(), "[state_name]", frame = i)

				else if(dirs == 4)
					blank.Insert(blank(), "[state_name]", NORTH, frame = i)
					blank.Insert(blank(), "[state_name]", SOUTH, frame = i)
					blank.Insert(blank(), "[state_name]", EAST, frame = i)
					blank.Insert(blank(), "[state_name]", WEST, frame = i)

				else if(dirs == 8)
					blank.Insert(blank(), "[state_name]", NORTH, frame = i)
					blank.Insert(blank(), "[state_name]", SOUTH, frame = i)
					blank.Insert(blank(), "[state_name]", EAST, frame = i)
					blank.Insert(blank(), "[state_name]", WEST, frame = i)
					blank.Insert(blank(), "[state_name]", NORTHEAST, frame = i)
					blank.Insert(blank(), "[state_name]", NORTHWEST, frame = i)
					blank.Insert(blank(), "[state_name]", SOUTHEAST, frame = i)
					blank.Insert(blank(), "[state_name]", SOUTHWEST, frame = i)
