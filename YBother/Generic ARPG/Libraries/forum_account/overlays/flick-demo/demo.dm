
world
	fps = 30

mob
	step_size = 8
	icon_state = "mob"

	var
		Overlay/coat
		Overlay/hat

	Login()
		..()

		// Give the mob a coat and a hat.
		coat = overlay("blue coat")
		hat = overlay('overlays-hat-icons.dmi')

	verb
		// We have verbs to animate each overlay individually...
		Remove_Hat()
			hat.Flick("remove", 8)

		Remove_Coat()
			coat.Flick("blue coat remove", 8)

		// ... or animate both at the same time.
		Remove_Both()

			// the Flick() proc sleeps so we have to put each inside
			// a spawn statement, otherwise it'll animate the coat after
			// the hat animation is finished.
			spawn() hat.Flick("remove", 8)
			spawn() coat.Flick("blue coat remove", 8)

			world << "Now it's a party!"

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