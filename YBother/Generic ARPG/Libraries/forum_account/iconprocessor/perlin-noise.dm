
// File:    perlin-noise.dm
// Library: Forum_account.IconProcessor
// Author:  Forum_account
//
// Contents:
//   This file contains the IconProcessor object which
//   you can define a custom type of to create your own
//   icon operations.

PerlinNoise
	parent_type = /Noise

	var
		const
			SIZE = 5
			LINEAR = 1
			COSINE = 2

		list/noise[SIZE][SIZE][SIZE]
		interpolation = COSINE
		levels = 1

		Vector/offset = new /Vector()
		scale = 1.0

		scale_x = 1
		scale_y = 1
		scale_z = 1

	New()
		// for each value in the noise array...
		for(var/x = 1 to SIZE)
			for(var/y = 1 to SIZE)
				for(var/z = 1 to SIZE)
					var/Vector/v

					// ...generate a random vector of length 1 or less
					while(1)
						v = new /Vector(rand() * 2.0 - 1.0, rand() * 2.0 - 1.0, rand() * 2.0 - 1.0)
						if(v.length_squared() > 1.0) continue
						break

					noise[x][y][z] = v

	value(wx, wy, wz, levels = 0)

		if(!levels)
			levels = src.levels

		wx = (wx + offset.x) * scale * scale_x
		wy = (wy + offset.y) * scale * scale_y
		wz = (wz + offset.z) * scale * scale_z

		var/amplitude = 1
		var/Vector/sum = new /Vector()

		for(var/i = 1 to levels)
			var/Vector/v = __value(wx, wy, wz)
			sum = Vector.sum(sum, Vector.scale(v, amplitude))

			amplitude *= 0.5

			wx *= 2.0
			wy *= 2.0
			wz *= 2.0

		return sum

	proc
		__value(wx, wy, wz)
			var/x = round(wx)
			var/y = round(wy)
			var/z = round(wz)

			var/a = wx - x
			var/b = wy - y
			var/c = wz - z

			if(interpolation == COSINE)
				a = 0.5 - cos(a * 180) * 0.5
				b = 0.5 - cos(b * 180) * 0.5
				c = 0.5 - cos(c * 180) * 0.5

			var/Vector/v1 = __get_value(x    , y    , z    )
			var/Vector/v2 = __get_value(x + 1, y    , z    )
			var/Vector/v3 = __get_value(x    , y    , z + 1)
			var/Vector/v4 = __get_value(x + 1, y    , z + 1)
			var/Vector/v5 = __get_value(x    , y + 1, z    )
			var/Vector/v6 = __get_value(x + 1, y + 1, z    )
			var/Vector/v7 = __get_value(x    , y + 1, z + 1)
			var/Vector/v8 = __get_value(x + 1, y + 1, z + 1)

			return  Vector.sum(
					Vector.scale(v1, (1.0 - a) * (1.0 - b) * (1.0 - c)),
					Vector.scale(v2, (      a) * (1.0 - b) * (1.0 - c)),
					Vector.scale(v3, (1.0 - a) * (1.0 - b) * (      c)),
					Vector.scale(v4, (      a) * (1.0 - b) * (      c)),
					Vector.scale(v5, (1.0 - a) * (      b) * (1.0 - c)),
					Vector.scale(v6, (      a) * (      b) * (1.0 - c)),
					Vector.scale(v7, (1.0 - a) * (      b) * (      c)),
					Vector.scale(v8, (      a) * (      b) * (      c)))

		__get_value(x, y, z)
			while(x < 0) x += SIZE
			while(y < 0) y += SIZE
			while(z < 0) z += SIZE
			x = (x % SIZE) + 1
			y = (y % SIZE) + 1
			z = (z % SIZE) + 1

			return noise[x][y][z]
