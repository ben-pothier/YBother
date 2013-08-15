
Fade
	parent_type = /IconProcessor

	var
		opacity = 0

	New(o)
		opacity = o

	// to apply the fade effect we process each state pixel by pixel.
	state()
		per_pixel()

		// output the icon, state name, direction, and frame number
		show_progress()

	pixel()

		// get the color at the current x/y
		var/Color/c = get(x, y)

		// if the pixel isn't already more than 50%
		// transparent, make it 50% transparent.
		if(c.a > opacity)
			c.a = opacity

		return c