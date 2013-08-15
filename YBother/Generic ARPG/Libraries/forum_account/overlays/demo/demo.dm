
mob
	step_size = 1
	icon_state = "mob"

	var
		Overlay/coat
		Overlay/hat
		Overlay/caption

	Login()
		..()

		// Because we only specify an icon state, this overlay
		// will use the same icon as the mob's icon.
		coat = overlay("blue coat")

		// Because we only specify an icon and not an icon state,
		// this overlay's state will always match our mob's icon
		// state. If we use the "Toggle Size" verb the hat icon
		// will always match the mob
		hat = overlay('overlays-hat-icons.dmi')

		// Create an overlay with no icon or icon state. We'll
		// just attach text to it to display the player's name
		// below their mob.
		caption = overlay()
		caption.Text("<text align=center>[name]")
		caption.PixelY(-12)

	verb
		// This changes the mob's icon, which will let us see that
		// the hat overlay is automatically updated to match.
		Toggle_Size()
			if(icon_state == "mob")
				icon_state = "short"
			else
				icon_state = "mob"

		// These show how to change an overlay's icon state.
		Red_Coat()
			if(coat)
				coat.IconState("red coat")
			else
				src << "You deleted the coat overlay!"

		Blue_Coat()
			if(coat)
				coat.IconState("blue coat")
			else
				src << "You deleted the coat overlay!"

		// This shows how to animate a single overlay.
		Drop_Hat()
			hat.Flick("remove", 8)

		// Deleting the coat overlay will remove it.
		Delete_Coat()
			del coat

		RGB_Test()
			coat.RGB(rand(0,255), 0, 0)

// The rest of the code in this file is needed by the demo but doesn't
// have anything to do specifically with the overlays library.

world
	view = 6

atom
	icon = 'overlays-demo-icons.dmi'

turf
	icon_state = "grass"

	pavement
		icon_state = "pavement"

	sidewalk
		icon_state = "sidewalk"

	brick
		density = 1
		icon_state = "brick"