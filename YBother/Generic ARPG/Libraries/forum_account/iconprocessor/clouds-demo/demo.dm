
CloudProcessor
	parent_type = /IconProcessor

	// this operates on 128x128 images
	width = 128
	height = 128

	var
		PerlinNoise/perlin = new()

	New()
		..()
		perlin.levels = 3
		perlin.scale = 0.1

	// process each pixel
	state()
		per_pixel()

	// for each pixel we get a noise value and use it to
	// offset the coordinates we use to sample the image,
	// this gives us a random (but consistent) distortion
	// to the cloud image.
	pixel()
		// get a noise value for the pixel's location
		var/Vector/v = perlin.value(x, y, 0.5)

		// use the noise value as an offset when sampling the icon
		return sample(x + v.x * 10, y + v.y * 10)

mob
	icon_state = "mob"

	Login()
		..()

		src << "Click on a cloud to generate a random cloud image for it."
		src << ""
		src << "This can take a while, so the demo comes with a pre-generated random icon. Use the 'shortcut' verb to give the clouds random cloud icons I already generated."

	cloud
		// when you click on a cloud, create a cloud processor
		// and run the input cloud icon through it.
		Click()
			var/CloudProcessor/cloud = new()
			icon = cloud.process('clouds-demo-icons.dmi')

	verb
		shortcut()
			for(var/mob/cloud/c in world)
				c.icon = 'pregenerated-clouds.dmi'
				c.icon_state = pick("1", "2", "3", "4")


// The rest of the code here is necessary for the demo but doesn't
// have anything to do with using the IconProcessing library.

world
	view = 5

mob
	cloud
		icon = 'clouds-demo-icons.dmi'

		density = 0
		glide_size = 3
		layer = MOB_LAYER + 5

		New()
			..()
			loop()

		proc
			loop()
				spawn()
					while(1)
						// if the cloud is at the bottom or right edge of the map
						if(y == 1 || x == world.maxx)

							// move it to the left or top edge of the map
							var/new_x = 1
							var/new_y = world.maxy

							if(prob(50))
								new_x = rand(1, world.maxx)
							else
								new_y = rand(1, world.maxy)

							loc = locate(new_x, new_y, z)

						// otherwise move it one tile
						else
							step(src, SOUTHEAST)

						sleep(16 * world.tick_lag)

atom
	icon = 'icon-processor-demo-icons.dmi'

turf
	icon_state = "grass"

	sidewalk
		icon_state = "sidewalk"

	floor
		icon_state = "floor"

	brick
		density = 1
		icon_state = "brick"