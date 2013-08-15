
// File:    demo\turfs.dm
// Library: Forum_account.ActionRpgFramework
// Author:  Forum_account
//
// Contents:
//   This file defines the turfs used in the project.
//   There's nothing special here, it's the same kind
//   of definitions you'd see in any project.

turf
	icon = 'turfs.dmi'
	icon_state = "grass-01"
	MapColor=rgb(0,155,0)
	sand_01
		icon_state = "sand-01"
		MapColor=rgb(102,51,0)
	blacksmith__floor_01
		icon_state = "blacksmith-01"
		MapColor=rgb(30,30,30)
	arcane_floor_01
		icon_state = "arcane-01"
		MapColor=rgb(102,0,51)
	carpentry_floor_01
		icon_state = "carpentry-01"
		MapColor=rgb(102,70,70)

	New()
		..()
		dir = dir8()

		if(!density)
			var/n = autojoin47("density")
			if(n > 0)
				overlays += icon('shadow-47.dmi', "[n]")

		else
			var/n = autojoin16("density")
			if(n < 15)
				overlays += icon('walls.dmi', "outline-[n]")

	wall_01
		icon = 'walls.dmi'
		density = 1
		icon_state = "wall-01"
		MapColor=rgb(102,102,102)
	blacksmth_01
		icon = 'walls.dmi'
		density = 1
		icon_state = "blacksmith-01"
		MapColor=rgb(151,151,151)
	arcane_01
		icon = 'walls.dmi'
		density = 1
		icon_state = "arcane-01"
		MapColor=rgb(200,0,150)
	carpentry_01
		icon = 'walls.dmi'
		density = 1
		icon_state = "carpentry-01"
		MapColor=rgb(150,100,0)



	stone_01
		icon = 'walls.dmi'
		density = 1
		icon_state = "stone-01"
		MapColor=rgb(102,0,0)

	wood_01
		icon = 'walls.dmi'
		density = 1
		icon_state = "wood-01"
		MapColor=rgb(0,51,0)

	/*
	wall_01
		icon = 'walls.dmi'
		icon_state = "wall-01"
		density = 1

	wall_02
		icon = 'walls.dmi'
		icon_state = "wall-02"
		density = 1

	wall_03
		icon = 'walls.dmi'
		icon_state = "wall-03"
		density = 1
	*/

	floor_01
		icon_state = "floor-01"
		MapColor=rgb(0,0,51)
obj
	icon = 'objects.dmi'
	density = 1
	Clutter
		bush
			icon_state = "bush"
		seedling
			icon_state = "seedling"
			density = 0
		crab_grass
			icon_state = "crab-grass"
			density = 0
	Tree
		icon = 'tree.dmi'

	Furniture
		wood_counter
			icon_state = "wooden-counter"
		wood_counter_v
			icon_state = "wooden-counter-vertical"
		wood_counter_ve
			icon_state = "wooden-counter-vertical_east"
		wood_counter_corner_e
			icon_state = "wooden-counter-corner_east"
		wood_counter_corner
			icon_state = "wooden-counter-corner"
		chair_east
			icon_state = "chair-east"
		chair_west
			icon_state = "chair-west"
		chair_south
			icon_state = "chair-south"
		chair_north
			icon_state = "chair-north"
	Cliffs
		density = 1
		cliff
			icon_state = "cliff"
		cliff_top
			icon_state = "cliff-top"
		cliff_top_right
			icon_state = "cliff-top-right"
			density = 0
		cliff_top_left
			icon_state = "cliff-top-left"
			density = 0
		cliff_bottom
			icon_state = "cliff-bottom"
		cliff_bottom_right
			icon_state = "cliff-bottom-right"
		cliff_bottom_left
			icon_state = "cliff-bottom-left"
		cliff_left
			icon_state = "cliff-left"
			density = 0
		cliff_right
			icon_state = "cliff-right"
			density = 0
			layer = 3
		cliff_grass
			icon_state = "cliff-grass"
			density = 0
		cliff_grass_right
			icon_state = "cliff-grass-right"
			density = 0
		cliff_grass_left
			icon_state = "cliff-grass-left"
			density = 0
		cliff_grass_top
			icon_state = "cliff-grass-top"
			density = 0
		cliff_grass_top_right
			icon_state = "cliff-grass-top-right"
			density = 0
		cliff_grass_top_left
			icon_state = "cliff-grass-top-left"
			density = 0