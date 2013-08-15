
// File:    demo\conditions.dm
// Library: Forum_account.ActionRpgFramework
// Author:  Forum_account
//
// Contents:
//   This file contains the conditions used in the
//   sample game. For now, there's only the Poisoned
//   condition.

Condition
	Poisoned
		// 4 ticks spaced 40 frames (one second) apart
		tick_count = 4
		tick_rate = 40

		// this is the icon state in framework-effects.dmi that is
		// used to show when the player has this condition.
		icon_state = "poisoned"

		// each tick deals 4 damage to the target
		tick()
			MagicCombat.attack(owner, target, 4)

			// make the poison effect attached so it follows
			// the target as they move.
			target.effect("poison", attached = 1)
	Slowed
		duration = 40
		icon_state = "slowed"

		// this condition just modifies the player's "slowed" var, which
		// keeps count of how many slowing effects they have. in mobs.dm
		// we check this var and set their movement speed accordingly.
		apply()
			target.slowed += 1

		remove()
			target.slowed -= 1
	Paralyzed
		icon_state = "paralyzed"
		duration = 100

		apply()
			target.paralyzed = 1
			owner << "You paralyzed [target]!"
			target.effect("paralyzed", attached = 1)

		remove()
			target.paralyzed = 0
			owner << "[target]'s paralysis wore off!"

	Pvp
		icon_state = "pvp"

		apply()
			target.pvp = 1

		remove()
			target.pvp = 0
