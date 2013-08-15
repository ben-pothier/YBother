
mob
	icon_state = "mob"

	var
		Overlay/health_bar
		Overlay/coat
		Overlay/hat

	Login()
		..()
		health_bar = overlay("health-bar")
		health_bar.PixelY(-6)

		hat = overlay('overlays-hat-icons.dmi')

		coat = overlay("blue coat")
		coat.ShowTo(src)

		src << "You can only appreciate what this demo does if you host it and connect a second instance of Dream Seeker."
		src << "Initially your health bar is shown to all players (it's an overlay). When you use the \"private health bar\" verb, your health bar will only be shown to you. It'll automatically be converted to an image object so it's not visible to other players."

	verb
		flick_coat()
			coat.Flick("blue coat remove", 8)

		toggle_health_bar()
			health_bar.Toggle()
			status()

		private_health_bar()
			health_bar.ShowTo(src)
			status()

		public_health_bar()
			health_bar.ShowToAll()
			status()

		above_player()
			health_bar.PixelY(32)
			status()

		below_player()
			health_bar.PixelY(-6)
			status()

	proc
		status()
			src << (health_bar.visible ? "visible\c" : "hidden\c")
			src << "\t\c"
			src << (health_bar.image ? "image\c" : "overlay\c")
			src << "\t\c"
			src << health_bar.PixelY()


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