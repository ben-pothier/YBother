
mob
	Login()

		// create the necessary processors. Each of these are
		// taken from other demos, so you can view each demo
		// for more details about how they work.
		var/Brightness/brightness = new(2.0)
		var/Fade/fade = new(0.5)
		var/Rotate/rotate = new(30)

		// process the sample icon
		var/icon/result = 'icon-processor-demo-icons.dmi'

		// the resulting icon will be darker, 50% transparent,
		// and rotated 30 degrees.
		result = brightness.process(result)
		result = fade.process(result)
		result = rotate.process(result)


		// save the result as "combo.dmi"
		src << ftp(result, "combo.dmi")
