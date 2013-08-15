
// File:    icon-processor.dm
// Library: Forum_account.IconProcessor
// Author:  Forum_account
//
// Contents:
//   This file contains the IconProcessor object which
//   you can define a custom type of to create your own
//   icon operations.

IconProcessor
	var
		const
			LINEAR = 1
			COSINE = 2

			BILINEAR = 1
			NEAREST_NEIGHBOR = 2

		icon/canvas
		color = "#000000"

		state

		width = 32
		height = 32

		x = 0
		y = 0

		center_x = 0
		center_y = 0

		interpolation = LINEAR
		sampling = BILINEAR

		icon/base_icon

		icon_state
		dir
		frame

	proc
		state()

		per_pixel()
			for(var/a = 1 to width)
				for(var/b = 1 to height)
					x = a
					y = b

					// we pass the pixel() proc the same arguments
					// that were passed to per_pixel()
					var/c = pixel(arglist(args))
					var/rgb

					if(istext(c))
						rgb = c
					else if(isnum(c))
						rgb = rgb(c * 255, c * 255, c * 255)
					else if(istype(c, /Color))
						rgb = c:RGB()

					canvas.DrawBox(rgb, x, y)

		process(icon/input_icon)

			center_x = (1 + width) / 2
			center_y = (1 + height) / 2

			if(istype(input_icon, /Template))
				var/Template/t = input_icon
				input_icon = t.blank

			var/icon/result = new()
			var/list/dirs = list(SOUTH, NORTH, EAST, WEST, SOUTHEAST, SOUTHWEST, NORTHEAST, NORTHWEST)

			var/list/arguments = args.Copy()
			if(arguments.len > 1)
				arguments.Cut(1, 2)

			for(var/s in icon_states(input_icon))

				for(var/d in dirs)
					var/f = 1

					while(1)
						base_icon = icon(input_icon, s, dir = d, frame = f)

						var/old_color = base_icon.GetPixel(1, 1)

						// try drawing a pixel
						base_icon.DrawBox(rgb(0,0,0), 1, 1)

						// if the black pixel didn't show up, this icon is null and
						// this frame/dir pair doesn't exist.
						if(isnull(base_icon.GetPixel(1, 1)))
							break

						// if this frame/dir pair exists, erase the pixel we drew
						base_icon.DrawBox(old_color, 1, 1)
						base_icon.Scale(width, height)

						canvas = blank()
						icon_state = s
						dir = d
						frame = f
						state(arglist(arguments))

						result.Insert(canvas, "[s]", d, f)
						f += 1

			return result

		get(a, b)
			if(isnull(a)) a = x
			if(isnull(b)) b = y

			if(a < 0 || a > base_icon.Width())
				return new /Color()

			if(b < 0 || b > base_icon.Height())
				return new /Color()

			return new /Color(base_icon.GetPixel(a, b))

		// interpolate the pixels surrounding (u,v)
		sample(u, v)

			var/i = round(u)
			var/j = round(v)

			// a b
			// d c
			var/a = get(i    , j + 1)
			var/b = get(i + 1, j + 1)
			var/c = get(i + 1, j)
			var/d = get(i    , j)

			u = u - i
			v = v - j

			if(sampling == BILINEAR)
				return bilinear(u, v, a, b, c, d)
			else if(sampling == NEAREST_NEIGHBOR)
				return nearest_neighbor(u, v, a, b, c, d)

		nearest_neighbor(u, v, Color/a, Color/b, Color/c, Color/d)

			// a b
			// d c
			if(u < 0.5)
				if(v < 0.5)
					return d
				else
					return a
			else
				if(v < 0.5)
					return c
				else
					return b

		// a b
		// d c
		// a is weighted by (1-u) and (v)
		// b is weighted by (u) and (v)
		// c is weighted by (u) and (1-v)
		// d is weighted by (1-u) and (1-v)
		bilinear(u, v, Color/a, Color/b, Color/c, Color/d)

			var/rs = 0
			var/gs = 0
			var/bs = 0
			var/ts = 0
			var/count = 0

			if(a.a > 0)
				rs += a.r * (1 - u) * (v)
				gs += a.g * (1 - u) * (v)
				bs += a.b * (1 - u) * (v)
				count += 1

			if(b.a > 0)
				rs += b.r * (u) * (v)
				gs += b.g * (u) * (v)
				bs += b.b * (u) * (v)
				count += 1

			if(c.a > 0)
				rs += c.r * (u) * (1 - v)
				gs += c.g * (u) * (1 - v)
				bs += c.b * (u) * (1 - v)
				count += 1

			if(d.a > 0)
				rs += d.r * (1 - u) * (1 - v)
				gs += d.g * (1 - u) * (1 - v)
				bs += d.b * (1 - u) * (1 - v)
				count += 1

			ts += a.a * (1 - u) * (v)
			ts += b.a * (u) * (v)
			ts += c.a * (u) * (1 - v)
			ts += d.a * (1 - u) * (1 - v)

			return new /Color(rs, gs, bs, ts)


		// get the intensity of the specified pixel
		intensity(a, b)
			var/Color/c = get(a, b)
			return c.intensity()

		overlay(icon/i)
			canvas.Blend(i, ICON_OVERLAY)

		multiply(icon/i)
			canvas.Blend(i, ICON_MULTIPLY)

		underlay(icon/i)
			canvas.Blend(i, ICON_UNDERLAY)

		blank()
			var/icon/i = icon('icon-library.dmi', "blank")

			if(width != 32 || height != 32)
				i.Scale(width, height)

			return i

		box(x1, y1, x2 = x1, y2 = y1)
			canvas.DrawBox(color, x1, y1, x2, y2)

		pixel(s)
			return color

		// a, b, c, and d are the corners in clockwise order
		// from the top-left.
		//
		//     a   b
		//
		//     d   c
		//
		interpolate()

			var/simple = 1
			var/tx, ty, a, b, c, d, e, f, g, h, i

			if(!args)
				CRASH("Wrong number of arguments for interpolate, expected 4, 6, 9, or 11, got 0.")
			if(args.len == 4)
				tx = x
				ty = y
				a = args[1]
				b = args[2]
				c = args[3]
				d = args[4]

			else if(args.len == 6)
				tx = args[1]
				ty = args[2]
				a = args[3]
				b = args[4]
				c = args[5]
				d = args[6]

			else if(args.len == 9)
				tx = x
				ty = y
				a = args[1]
				b = args[2]
				c = args[3]
				d = args[4]
				e = args[5]
				f = args[6]
				g = args[7]
				h = args[8]
				i = args[9]
				simple = 0

			else if(args.len == 11)
				tx = args[1]
				ty = args[2]
				a = args[3]
				b = args[4]
				c = args[5]
				d = args[6]
				e = args[7]
				f = args[8]
				g = args[9]
				h = args[10]
				i = args[11]
				simple = 0
			else
				CRASH("Wrong number of arguments for interpolate, expected 4, 6, 9, or 11, got [args.len].")

			if(simple)
				tx = (tx - 1) / (width - 1)
				ty = (ty - 1) / (height - 1)

				if(interpolation == COSINE)
					tx = cos(tx * 180) * -0.5 + 0.5
					ty = cos(ty * 180) * -0.5 + 0.5

				. = a * (1 - tx) * (ty) + \
				    b * (tx)     * (ty) + \
				    c * (tx)     * (1 - ty) + \
				    d * (1 - tx) * (1 - ty)

			else
				// a b c    a b c
				// d e f    h i d
				// g h i    g f e
				if(tx <= 16)
					tx = (tx - 0.5) * 2
					if(ty <= 16)
						ty = (ty - 0.5) * 2
						return interpolate(tx, ty, h, i, f, g)
					else
						ty = (ty - 16.5) * 2
						return interpolate(tx, ty, a, b, i, h)
				else
					tx = (tx - 16.5) * 2
					if(ty <= 16)
						ty = (ty - 0.5) * 2
						return interpolate(tx, ty, i, d, e, f)
					else
						ty = (ty - 16.5) * 2
						return interpolate(tx, ty, b, c, d, i)

		show_progress()
			world << "\icon[canvas] \[icon_state = '[icon_state]', dir = [dir2txt(dir)], frame = [frame]]"
			sleep(0)
