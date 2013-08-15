
// File:    noise.dm
// Library: Forum_account.IconProcessor
// Author:  Forum_account
//
// Contents:
//   This file contains the basic definitions needed to
//   create custom noise functions.

Noise
	proc
		value()

var
	VectorOps/Vector = new /VectorOps()

VectorOps
	proc
		euclidean_distance(Vector/a, Vector/b)
			return sqrt((a.x - b.x) ** 2 + (a.y-b.y) ** 2)

		manhattan_distance(Vector/a, Vector/b)
			return abs(a.x - b.x) + abs(a.y - b.y)

		sum()
			var/Vector/r = new /Vector()
			for(var/Vector/v in args)
				r.x += v.x
				r.y += v.y
				r.z += v.z
			return r

		scale(Vector/v, s)
			return new /Vector(v.x * s, v.y * s, v.z * s)

Vector
	var
		x
		y
		z
	New(a = 0, b = 0, c = 0)
		x = a
		y = b
		z = c

	proc
		len()
			return sqrt(x*x + y*y + z*z)

		length_squared()
			return x*x + y*y + z*z

		RGB()
			var/r = round(x * 256)
			var/g = round(y * 256)
			var/b = round(z * 256)
			if(r < 0) r = 0
			if(g < 0) g = 0
			if(b < 0) b = 0
			if(r > 255) r = 255
			if(g > 255) g = 255
			if(b > 255) b = 255
			return rgb(r, g, b)

		str()
			return "\[[x] [y] [z]]"
