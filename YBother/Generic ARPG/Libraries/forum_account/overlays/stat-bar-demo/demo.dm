
// This is the basic type we can use to create any kind of stat bar.
StatBar
	var
		atom/owner
		Overlay/overlay
		stat_name
		max_name

		icon
		state_name = ""
		num_states = 0

	New(atom/a)
		owner = a

		// do some error checking
		if(!owner)
			CRASH("An atom must be passed to the stat bar's constructor.")

		if(!(stat_name in owner.vars))
			CRASH("Invalid variable name '[stat_name]'.")

		if(!(max_name in owner.vars))
			CRASH("Invalid variable name '[stat_name]'.")

		if(!icon)
			CRASH("The stat bar must have an icon.")

		// if the number of states isn't specified, figure out
		// how many states there are.
		if(!num_states)
			while("[state_name][num_states]" in icon_states(icon))
				num_states += 1

			if(!num_states)
				CRASH("Couldn't find the icon state in [icon] named [state_name]0.")

			num_states -= 1

		// if the error checks pass, create the overlay
		overlay = owner.overlay(icon, "")
		update()

	proc
		// update the overlay's icon_state to reflect
		// the values the stat bar is monitoring.
		update()

			// find the stat's value
			var/value = owner.vars[stat_name]

			// and convert it to a percentage
			if(value > owner.vars[max_name])
				value = 1
			else if(value < 0)
				value = 0
			else
				value = value / owner.vars[max_name]

			// then multiply by the number of states
			value = round(value * num_states)

			// and update the overlay
			overlay.IconState("[state_name][value]")

// We set some properties of this object to make it specifically be a health meter.
HealthMeter
	parent_type = /StatBar

	// These are the names of the mob's vars used to figure
	// out how full the health meter should be.
	stat_name = "health"
	max_name = "max_health"

	// This is the icon that contains the health meter states
	icon = 'overlays-demo-icons.dmi'

	// This is the number of health meter icon states. We don't have
	// to specify this, it's just a convenience. If we comment this
	// line out it'll still work.
	num_states = 15

	// This is the prefix applied to all health meter icon states.
	state_name = "health-bar-"

	New()
		..()

		// shift the overlay down 7 pixels
		overlay.PixelY(-7)

mob
	icon_state = "blue-mob"

	var
		health = 20
		max_health = 20

		HealthMeter/health_meter

	Login()
		..()

		// the properties of the health meter (ex: the icon
		// states to use, the variables to use, etc.) are
		// defined as part of the /HealthMeter object type,
		// so we don't have to pass lots of arguments to the
		// constructor, just the mob getting the health bar.
		health_meter = new(src)

	verb
		// we just call the health meter's update() proc to
		// make it reflect the new health value.
		decrease_health()
			health -= 1
			health_meter.update()
			world << "health = [health] / [max_health]"

		increase_health()
			health += 1
			health_meter.update()

			world << "health = [health] / [max_health]"

		random_health()
			health = rand(0, max_health)
			health_meter.update()

			world << "health = [health] / [max_health]"

		// we can leverage all of the Overlay library's functions
		// by accessing the health meter's overlay object.
		toggle()
			health_meter.overlay.Toggle()



// The rest of the code in this file is needed by the demo but doesn't
// have anything to do specifically with the overlays library.

world
	view = 6

atom
	icon = 'overlays-demo-icons.dmi'

turf
	icon_state = "grass"

	pavement
		icon_state = "pavement"

	sidewalk
		icon_state = "sidewalk"

	brick
		density = 1
		icon_state = "brick"