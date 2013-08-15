
// This icon processor draws black outlines around the edge of
// the icon. It assumes the icon states are named 0 - 15 and it
// uses these numbers as bit flags to indicate which sides have
// outlines. The bit values (1, 2, 4, 8) correspond to the top,
// right, bottom, and left sides. For example:
//
//     +----+         +
//     |              |
//     |              |
//     +----+    +----+
//       13        6
//
// 13 is 1101 in binary, the bits that are set correspond to the
// top, bottom, and left sides. 6 is 0110 in binary, the bits that
// are set correspond to the right and bottom sides.

Outline
	parent_type = /IconProcessor

	// This proc gets called once for each state. Each call is
	// responsible for generating a single icon state.
	state()

		// the name of the state gives us the bit values
		var/n = text2num(icon_state)

		// fill in the sides of the icon based on the bit values
		if(n & 1) box(1, 32, 32, 32)
		if(n & 2) box(32, 1, 32, 32)
		if(n & 4) box(1, 1, 32, 1)
		if(n & 8) box(1, 1, 1, 32)

		// output the icon, state name, direction, and frame number
		show_progress()

mob
	Login()

		// create a template with states named 0 - 15
		for(var/i = 0 to 15)
			template.add_state(i)

		// create the outline generator
		var/Outline/outline = new()

		// process the template
		var/icon/result = outline.process(template)

		// save the result as "outline.dmi"
		src << ftp(result, "outline.dmi")
