
ScreenBorder
	parent_type = /HudGroup

	icon = 'border-demo.dmi'
	layer = MOB_LAYER + 5

	var
		HudObject/top
		HudObject/bottom
		HudObject/left
		HudObject/right

	New()
		..()

		// create an object for each side of the screen
		top = add(0, 0, "top")
		bottom = add(0, 0, "bottom")
		left = add(0, 0, "left")
		right = add(0, 0, "right")

	proc
		update(width, height)

			// make the top/bottom objects match the screen's width
			bottom.size(width, 1)
			top.size(width, 1)

			// make the left/right objects match the screen's height
			left.size(1, height)
			right.size(1, height)

			// position the top and right objects properly, the left
			// and bottom objects always stay in the same position
			right.pos(width * 32 - 32, 0)
			top.pos(0, height * 32 - 32)

mob
	var
		// each player has a screen border
		ScreenBorder/screen_border

	Login()
		..()

		// create the screen border HUD object
		screen_border = new(src)

		// set the player's screen size
		screen_size(9, 9)

	verb
		Change_Screen_Size()
			var/width = input(src, "Screen width in tiles?") as num
			var/height = input(src, "Screen height in tiles?") as num
			screen_size(width, height)

	proc
		screen_size(width, height)
			client.view = "[width]x[height]"
			screen_border.update(width, height)

// the rest of this code is needed for the demo but doesn't
// relate to how you'd use the HUD library.
atom
	icon = 'hud-demo-icons.dmi'

turf
	icon_state = "grass"

	water
		density = 1
		icon_state = "water"

	trees
		density = 1
		icon_state = "trees"

	rock
		density = 1
		icon_state = "rock"

mob
	icon_state = "mob"
