
Brightness
	parent_type = /IconProcessor

	var
		exponent

	New(e)
		exponent = e

	state()
		per_pixel()
		show_progress()

	pixel()
		var/Color/c = get()

		// raise each color value to the specified exponent
		c.r = c.r ** exponent
		c.g = c.g ** exponent
		c.b = c.b ** exponent

		return c
