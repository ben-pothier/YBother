
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

mob
	Login()

		// raise each color value to the 0.5 power.
		// exponents less than 1 make the icons brighter, exponents
		// greater than 1 make it darker.
		var/Brightness/brightness = new(0.5)

		// process the sample icon
		var/icon/result = brightness.process('icon-processor-demo-icons.dmi')

		// save the result as "brightness.dmi"
		src << ftp(result, "brightness.dmi")
