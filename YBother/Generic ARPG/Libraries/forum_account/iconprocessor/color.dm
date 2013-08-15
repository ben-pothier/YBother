
// File:    color.dm
// Library: Forum_account.IconProcessor
// Author:  Forum_account
//
// Contents:
//   This file contains the Color datum, which stores
//   RGBA values as decimals between zero and one. It's
//   constructor can take a string of the form "#RRGGBB"
//   or "#RRGGBBAA", or it can take three or four numbers
//   (the individual RGBA values).

Color
	var
		r = 0
		g = 0
		b = 0
		a = 0

	New()
		if(!args)
		else if(args.len == 1)

			// null is passed in when GetPixel() hits a mask pixel
			if(isnull(args[1]))
				a = 0

			// #RRGGBB
			else if(length(args[1]) < 8)
				r = int(copytext(args[1], 2, 4), 16)
				g = int(copytext(args[1], 4, 6), 16)
				b = int(copytext(args[1], 6, 8), 16)
				a = 255

			// #RRGGBBAA
			else
				r = int(copytext(args[1], 2, 4), 16)
				g = int(copytext(args[1], 4, 6), 16)
				b = int(copytext(args[1], 6, 8), 16)
				a = int(copytext(args[1], 8, 10), 16)

			// put the RGBA values in the 0 - 1 range
			r /= 255
			g /= 255
			b /= 255
			a /= 255

		// if 3 or 4 args are passed in, those are the RGBA values
		else if(args.len == 3)
			r = args[1]
			g = args[2]
			b = args[3]

		else if(args.len == 4)
			r = args[1]
			g = args[2]
			b = args[3]
			a = args[4]

	proc
		RGB()
			if(a == 1)
				return rgb(r * 255, g * 255, b * 255)
			else
				return rgb(r * 255, g * 255, b * 255, a * 255)

		intensity()
			if(a == 1)
				return (r + g + b) / 3
			else
				var/c = (r + g + b) / 3
				return rgb(c * 255, c * 255, c * 255, a * 255)