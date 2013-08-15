
Rotate
	parent_type = /IconProcessor

	// bilinear is the default sampling mode, so uncomment
	// this line to use nearest-neighbor.
	// sampling = NEAREST_NEIGHBOR

	var
		angle = 0

	New(a)
		angle = a

	// to apply the fade effect we process each state pixel by pixel.
	state()
		per_pixel()

		// output the icon, state name, direction, and frame number
		show_progress()

	pixel()
		/// find the icon coordinates relative to the center of rotation
		var/ix = x - center_x
		var/iy = y - center_y

		// rotate the coordinates
		var/rx = ix * cos(angle) - iy * sin(angle)
		var/ry = ix * sin(angle) + iy * cos(angle)

		// shift the coordinates back to being relative to the icon
		rx = rx + center_x
		ry = ry + center_y

		// sample the image at the resulting coordinates
		return sample(rx, ry)