
// This is similar to the outline-demo because we use bit values
// to encode information about the icon. Here, the values represent
// the values of each icon of the corner. Each corner can be black
// (the bit is set) or transparent (the bit is zero).
//
// The icon we generate is a gradient created by interpolating the
// corner values. To generate this we calculate the color at each
// pixel using the per_pixel() and pixel() procs.

Gradient
	parent_type = /IconProcessor

	// uncomment this line to change the interpolation
	// mode from linear to cosine.
	// interpolation = COSINE

	// we generate each state a pixel at a time. calling the per_pixel()
	// proc will call the pixel() proc for each pixel of the icon.
	state()
		per_pixel()
		show_progress()

	// this is called for every pixel of the icon. All we have
	// to do here is return a color and the pixel will automatically
	// be filled in with that color.
	pixel()

		var/n = text2num(icon_state)

		// the bit values are the corner values - either 0 or 1
		// for transparent or black.
		var/tl = (n & 1) ? 1 : 0
		var/tr = (n & 2) ? 1 : 0
		var/br = (n & 4) ? 1 : 0
		var/bl = (n & 8) ? 1 : 0

		// do a bi-linear interpolation for the current x/y
		var/t = interpolate(tl, tr, br, bl)

		return rgb(0, 0, 0, 255 * t)

mob
	Login()

		// create a template with states named 0 - 15
		for(var/i = 0 to 15)
			template.add_state(i)

		// create the icon generator, run it, and prompt
		// the user to save the output.
		var/Gradient/gradient = new()
		src << ftp(gradient.process(template), "gradient.dmi")
