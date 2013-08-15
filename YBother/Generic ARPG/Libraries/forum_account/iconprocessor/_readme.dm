/*

  -- Version History --

The IconProcessor's state() proc is called once for each cell
of the icon. If an icon state has one direction and isn't animated,
it only has one cell. If it's 8-directional and not animated it has
eight cells. The state() proc is passed the name of the icon state,
the direction of the cell, and the frame index of the cell (in that
order).

Version 3 (posted 03-17-2012)
 * Fixed a bug with how the icon processor checked if a state/dir/frame
   existed. It checks by drawing on the icon and checking if the drawing
   succeeded, but it didn't properly undo this operation when it did
   succeed and it caused the bottom-left pixel of all output icons to
   be blank.
 * Added brightness-demo which shows how to adjust the brightness of an
   icon by raising each color component to a power. This works because
   each color component is between 0 and 1. Raising any value in this range
   to a positive power will also produce a number in this range.
 * Fixed a bug with the icons that were produced. They'd always return zero
   for their width and height which caused problems if you tried to chain
   icon processors together.
 * Added chaining-demo which shows how to create composite effects by
   using the output of one icon processor as the input to another.
 * Added the animation-demo to show how to generate animated icons from
   the sample input file.

Version 2 (posted 03-15-2012)
 * Added noise.dm and perlin-noise.dm, which includes the PerlinNoise
   object.
 * Added clouds-demo which includes an example of how to use Perlin
   noise to modify icons. This example takes a basic white circle and
   uses Perlin noise to offset the coordinates when re-sampling the
   image to generate random variations that make the white circles
   look like clouds.

Version 1 (posted 03-15-2012)
 * Initial version.


  -- About the Library --

When you're generating icons or running an operation on existing
icons there's a lot of overhead. There are many loops and many
repeated operations that clutter up your code. The IconProcessor
object cuts out all of this overhead. Suppose you want to create
a new icon by changing the alpha channel for all pixels in an
existing icon, here's all you have to do:

	Fade
		parent_type = /IconProcessor

		state()
			per_pixel()

		pixel()
			var/Color/c = get(x, y)

			if(c.a > 128)
				c.a = 128

			return c

	// to process an icon and save the result
	var/Fade/fade = new()
	var/icon/result = fade.process('some-icon.dmi')
	src << ftp(result, "fade.dmi")

The Fade object is a type of icon processor. When you call the
IconProcessor's process() proc, it calls the state() proc for
every state in the input icon. The per_pixel() proc is also defined
by the IconProcessor. It calls the pixel() proc for every pixel in
the icon and sets that pixels color to the return value received
from the pixel() proc.

There is zero overhead here. The code seen above is the absolute
minimum you need. It's the part of the code that's specific to the
fade effect without being weighed down by everything else.


You can also use the IconProcessor to generate icons by providing
it a blank icon as input. You can use the Template object to create
a blank icon containing the states you need the icon to have. There
is a single global instance of the Template object that you can use,
for example:

	// create states named 0 - 15
	for(var/i = 0 to 15)
		template.add_state(i)

	// process the 16 blank states
	outline.process(template)

The add_state() proc is defined as:

	add_state(state_name, dirs = 1, frames = 1)

*/