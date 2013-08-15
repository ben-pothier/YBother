
// This demo creates an animated icon from the plain, non-animated
// input icons. This is a two step process. The first step is to
// generate an animated icon that takes the input icon and adds
// frames of animation. The second step is to apply an effect to
// each from of this extended icon to create the animation.
//
// The FrameExtend object applies the first step and the FadeIn
// object applies the second step. The result of each step is saved.

proc
	frame_extend(icon/i, frames = 1)

		// create a template that contains a blank animated state
		// for each icon state in the input icon and set the number
		// of frames to the specified amount.
		template.clear()
		for(var/state in icon_states(i))
			template.add_state(state, frames = frames)

		// create the frame extender, run it, and return its output
		var/FrameExtend/frame_extend = new()

		// the second argument, the input icon, is automatically
		// passed to the icon processor's state() proc.
		return frame_extend.process(template, i)

FrameExtend
	parent_type = /IconProcessor

	state(icon/input_icon)

		// we take the state from the input icon
		var/icon/base = icon(input_icon, icon_state)

		// and draw it to the canvas for each frame.
		overlay(base)

		show_progress()

FadeIn
	parent_type = /IconProcessor

	var
		frame_count = 1

	New(f)
		frame_count = f

	state()
		per_pixel()
		show_progress()

	pixel()
		var/Color/c = get()

		// we set the alpha channel based on the frame number
		// so as the index goes from 1 to 10, the opacity goes
		// from 10% to 100%.
		if(c.a > 0)
			c.a = frame / frame_count

		return c

mob
	Login()

		// extend the input icon so we can animate it
		var/icon/extended = frame_extend('icon-processor-demo-icons.dmi', 10)

		// save this intermediate result
		src << ftp(extended, "extended.dmi")

		// create the fade in processor
		var/FadeIn/fade_in = new(10)

		// process the icon to generate the fade in animations
		var/icon/result = fade_in.process(extended)

		// save the result
		src << ftp(result, "fade-in.dmi")