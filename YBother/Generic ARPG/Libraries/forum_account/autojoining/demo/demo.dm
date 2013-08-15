
turf
	// call the autojoin proc when a turf is created.
	New()
		..()

		// give all non-dense turfs a 47-state autojoining shadow.
		if(!density)
			var/n = autojoin47("density")
			overlays += icon('autojoining-demo-shadow-47.dmi', "[n]")

		// give all dense turfs a 16-state autojoining outline.
		else
			var/n = autojoin16("density")
			overlays += icon('autojoining-demo-icons.dmi', "outline-[n]")

	// in addition to the default autojoining, we give
	// sidewalk turfs a random direction.
	sidewalk
		New()
			..()
			dir = dir4()

	// in addition to the default autojoining, we give
	// grass turfs a random direction.
	grass
		New()
			..()
			dir = dir8()

obj
	wire
		icon = 'autojoining-demo-wire-256.dmi'
		icon_state = "0"

		New()
			..()

			// we need to delay the call to autojoin256() since it
			// checks if neighboring tiles also contain wire objs,
			// if we call it without the delay, based on the order
			// that objects get created, not all neighboring wires
			// will exist when we call the autojoin proc.
			sleep(0)

			// make wires autojoin using 256 states.
			icon_state = "[autojoin256()]"

// The rest of this code is needed for the demo but doesn't
// have anything to do with the autojoining library.

atom
	icon = 'autojoining-demo-icons.dmi'

mob
	icon_state = "mob"

turf
	icon_state = "grass"

	floor
		icon_state = "floor"

	sidewalk
		icon_state = "sidewalk"

	brick
		density = 1
		icon_state = "brick"