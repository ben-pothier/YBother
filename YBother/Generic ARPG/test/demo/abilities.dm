
// File:    demo\abilities.dm
// Library: Forum_account.ActionRpgFramework
// Author:  Forum_account
//
// Contents:
//   This file contains definitions of three abilities,
//   two are melee attacks and one is a ranged attack.
//   These examples show how to create cooldowns, mana
//   costs, damage, graphical effects, and projectiles.

Ability
	Attack
		name = "Attack"
		description = "Deals damage to a single target."
		animation = "attacking"
		cooldown = 40
		xp_needed = 25
		xp_multiplier = 25
		level = 1
		icon_state = "ability-button-unarmed-attack"

		// can_use enforces the mana cost by default, we
		// override it to check the cooldown.
		can_use(mob/user)
			var/mob/target
			if(user.on_cooldown("attack"))
				return 0
			// make sure the user has a target
			if(icon_state == "ability-button-unarmed-attack" || icon_state == "ability-button-melee-attack")
				target = user.melee_target()
				if(!target)
					user.no_target_selected(src)
					return 0
			else if(icon_state == "ability-button-bow-attack")
				if(!user.can_attack(user.target))
					user.no_target_selected(src)
					return 0
				// and they have to be within range of their target
				if(user.distance_to(user.target) > 200)
					user.target_out_of_range(src)
					return 0
					// and they need line of sight to their target
				if(!user.los(user.target))
					user.no_line_of_sight(user.target)
					return 0
			else if(icon_state == "ability-button-magic-attack")
				if(user.on_cooldown("attack"))
					return 0
				else
					return ..()

			return ..()

		effect(mob/user)
			..()
			var/mob/target
			var/item/i
			// find a target in the attacker's melee range
			if(icon_state == "ability-button-unarmed-attack")
				target = user.melee_target()
				target.effect("punch")
				target.noise('hit-1.wav', frequency = rand(0.7, 1.3))
				PhysicalCombat.attack(user, target, user.power)
			else if(icon_state == "ability-button-melee-attack")
				target = user.melee_target()
				target.effect("dagger-slash")
				if(user.equipment[TWO_HAND])
					i = user.equipment[TWO_HAND]
				else if(user.equipment[MAIN_HAND])
					i = user.equipment[MAIN_HAND]
				target.noise('hit-1.wav', frequency = rand(0.7, 1.3))
				PhysicalCombat.attack(user, target, i.power + user.power)
			else if(icon_state == "ability-button-bow-attack")
				new /missile/ShootArrow(user, user.target, level)
			else if(icon_state == "ability-button-magic-attack")
				new /projectile/Magic(user,user.target, level)

			// trigger a 40 tick cooldown for this ability and
			// a 10 tick cooldown for all attacks
			user.cooldown("attack", cooldown)
			// inflict damage and show a graphical effect on the target


	Poison
		name = "Poison"
		icon_state = "ability-button-poison"
		description = "Deals 16 damage over 4 seconds."
		animation = "attacking"
		cooldown = 80
		xp_needed = 15
		xp_multiplier = 15
		level = 1

		// poison also has a cooldown
		can_use(mob/user)
			if(user.on_cooldown("poison", "attack"))
				return 0

			// make sure the user has a target
			var/mob/target = user.melee_target()
			if(!target)
				user.no_target_selected(src)
				return 0

			return ..()

		effect(mob/user)
			..()
			var/mob/target = user.melee_target()

			user.cooldown("poison", cooldown)
			user.cooldown("attack", 10)

			// create the poisoned condition
			new /Condition/Poisoned(target, user)

			// show a graphical effect and play a sound
			target.effect("poison")
			target.noise('hit-1.wav', frequency = rand(0.7, 1.3))

	PowerSlash
		name = "Power Slash"
		icon_state = "ability-button-powerslash"
		description = "Deals heavy damage to a melee target."
		animation = "attacking"
		original_manaCost = 1
		mana_cost = 1
		cooldown = 60
		xp_needed = 25
		xp_multiplier = 25
		level = 1

		// cleave also has a cooldown
		can_use(mob/user)
			if(user.on_cooldown("power slash", "attack"))
				return 0

			// make sure there's at least one target in range.
			var/mob/target = user.melee_target()
			var/item/i
			if(!target)
				user.no_target_selected(src)
				return 0
			if(user.equipment)
				if(user.equipment[TWO_HAND])
					i = user.equipment[TWO_HAND]
					if(i.style == "melee")
						return ..()
					else
						user.no_melee_equipment(src)
						return 0
				else if(user.equipment[MAIN_HAND])
					i = user.equipment[MAIN_HAND]
					if(i.style == "melee")
						return ..()
					else
						user.no_melee_equipment(src)
						return 0
				else
					user.no_melee_equipment(src)
					return 0
			else
				return 0
			return ..()

		effect(mob/user)
			..()
			var/item/i
			var/mob/target = user.melee_target()
			if(user.equipment[TWO_HAND])
				i = user.equipment[TWO_HAND]
			else if(user.equipment[MAIN_HAND])
				i = user.equipment[MAIN_HAND]
			user.cooldown("power slash", cooldown)
			user.cooldown("attack", 10)

			// create the poisoned condition

			// show a graphical effect and play a sound
			target.effect("dagger-slash")
			target.noise('hit-1.wav', frequency = rand(0.7, 1.3))
			PhysicalCombat.attack(user, target, (i.power*2) + user.power)
	Cleave
		name = "Cleave"
		icon_state = "ability-button-cleave"
		description = "Deals damage to all melee targets."
		animation = "attacking"
		cooldown = 20
		xp_needed = 25
		xp_multiplier = 25
		level = 1

		// cleave also has a cooldown
		can_use(mob/user)
			if(user.on_cooldown("cleave", "attack"))
				return 0

			// make sure there's at least one target in range.
			var/list/targets = user.all_melee_targets()
			var/item/i
			if(!targets.len)
				user.no_target_selected(src)
				return 0
			if(user.equipment)
				if(user.equipment[TWO_HAND])
					i = user.equipment[TWO_HAND]
					if(i.style == "melee")
						return ..()
					else
						user.no_melee_equipment(src)
						return 0
				else if(user.equipment[MAIN_HAND])
					i = user.equipment[MAIN_HAND]
					if(i.style == "melee")
						return ..()
					else
						user.no_melee_equipment(src)
						return 0
				else
					user.no_melee_equipment(src)
					return 0
			else
				return 0
			return ..()

		effect(mob/user)

			// 20 tick ability cooldown, 10 tick attack cooldown
			user.cooldown("cleave", cooldown)
			user.cooldown("attack", 10)
			var/item/i
			if(user.equipment[TWO_HAND])
				i = user.equipment[TWO_HAND]
			else if(user.equipment[MAIN_HAND])
				i = user.equipment[MAIN_HAND]
			// damage all targets in melee range
			for(var/mob/target in user.all_melee_targets())
				gain_xp(1)
				PhysicalCombat.attack(user, target, (i.power/3) + user.power / 5)
				target.effect("sword-slash")
				target.noise('hit-2.wav', frequency = rand(0.7, 1.3))

	Fireball
		name = "Fireball"
		icon_state = "ability-button-fireball"
		description = "Shoots a fireball that deals magic damage."
		animation = "attacking"
		mana_cost = 3
		original_manaCost = 3
		cooldown = 30
		xp_needed = 10
		xp_multiplier = 10
		level = 1

		// fireball also has a cooldown
		can_use(mob/user)
			if(user.on_cooldown("fireball", "attack"))
				return 0
			else
				return ..()

		effect(mob/user)
			..()
			user.cooldown("fireball", cooldown)
			user.cooldown("attack", 10)

			// All we do is create the projectile, everything is handled
			// by the /projectile/fireball definition and the built-in
			// behavior of the /projectile type.
			//
			// If your target is null, the projectile's New proc (as defined
			// by the framework) will fire the projectile in the direction
			// you're facing. If your target isn't null, the projectile will
			// be fired in the precise direction of your target. That doesn't
			// mean it's guaranteed to hit your target, but it's better than
			// only being able to shoot in 8 directions.
			new /projectile/fireball(user, user.target, level)

			user.noise('fire.wav', frequency = rand(0.7, 1.3))
	AOE
		name = "AOE"
		icon_state = "ability-button-AOE"
		description = "Creates a ring of AOE"
		animation = "attacking"
		mana_cost = 10
		original_manaCost = 10
		cooldown = 30
		xp_needed = 10
		xp_multiplier = 10
		level = 1

		// fireball also has a cooldown
		can_use(mob/user)
			if(user.on_cooldown("AOE", "attack"))
				return 0
			else
				return ..()

		effect(mob/user)

			user.cooldown("AOE", cooldown)
			user.cooldown("attack", 10)

			// All we do is create the projectile, everything is handled
			// by the /projectile/fireball definition and the built-in
			// behavior of the /projectile type.
			//
			// If your target is null, the projectile's New proc (as defined
			// by the framework) will fire the projectile in the direction
			// you're facing. If your target isn't null, the projectile will
			// be fired in the precise direction of your target. That doesn't
			// mean it's guaranteed to hit your target, but it's better than
			// only being able to shoot in 8 directions.

			user.noise('fire.wav', frequency = rand(0.7, 1.3))

	Stun
		name = "Stun"
		icon_state = "ability-button-stun"
		description = "Paralyzes a target without dealing damage."
		animation = "attacking"
		mana_cost = 2
		original_manaCost = 2
		cooldown = 30
		xp_needed = 15
		xp_multiplier = 15
		level = 1

		// fireball also has a cooldown
		can_use(mob/user)
			if(user.on_cooldown("stun", "attack"))
				return 0
			else
				return ..()

		effect(mob/user)
			..()
			user.cooldown("stun", cooldown)
			user.cooldown("attack", 10)

			// All we do is create the projectile, everything is handled
			// by the /projectile/fireball definition and the built-in
			// behavior of the /projectile type.
			//
			// If your target is null, the projectile's New proc (as defined
			// by the framework) will fire the projectile in the direction
			// you're facing. If your target isn't null, the projectile will
			// be fired in the precise direction of your target. That doesn't
			// mean it's guaranteed to hit your target, but it's better than
			// only being able to shoot in 8 directions.
			new /projectile/lightning(user, user.target)

			user.noise('fire.wav', frequency = rand(0.7, 1.3))

	PoisonArrow
		name = "Poison Arrow"
		icon_state = "ability-button-poisonarrow"
		description = "Shoots an arrow that will also poison the target."
		animation = "attacking"
		mana_cost = 5
		original_manaCost = 5
		cooldown = 40
		xp_needed = 15
		xp_multiplier = 12
		level = 1

		// fireball also has a cooldown
		can_use(mob/user)
			if(user.on_cooldown("poison arrow", "attack"))
				return 0
			if(!user.can_attack(user.target))
				user.no_target_selected(src)
				return 0
			// and they have to be within range of their target
			if(user.distance_to(user.target) > 200)
				user.target_out_of_range(src)
				return 0
				// and they need line of sight to their target
			if(!user.los(user.target))
				user.no_line_of_sight(user.target)
				return 0
			return ..()
		effect(mob/user)
			..()
			user.cooldown("poison arrow", cooldown)
			user.cooldown("attack", 10)

			// All we do is create the projectile, everything is handled
			// by the /projectile/fireball definition and the built-in
			// behavior of the /projectile type.
			//
			// If your target is null, the projectile's New proc (as defined
			// by the framework) will fire the projectile in the direction
			// you're facing. If your target isn't null, the projectile will
			// be fired in the precise direction of your target. That doesn't
			// mean it's guaranteed to hit your target, but it's better than
			// only being able to shoot in 8 directions.
			new /missile/PoisonArrow(user, user.target, level)

missile
	ShootArrow
		move_speed = 15
		icon_state = "arrow"
		damage = 10

		hit(mob/m)
			PhysicalCombat.attack(owner, m, damage + round(owner.dexterity/5,2))
			m.effect("arrow-hit")
			m.noise('hit-1.wav', frequency = rand(0.7, 1.3))
	EnemyArrow
		move_speed = 15
		icon_state = "arrow"
		damage = 20

		hit(mob/m)
			PhysicalCombat.attack(owner, m, damage + owner.power)
			m.effect("arrow-hit")
			m.noise('hit-1.wav', frequency = rand(0.7, 1.3))
	PoisonArrow
		move_speed = 15
		icon_state = "arrow"

		hit(mob/m)
			PhysicalCombat.attack(owner, m, round(owner.dexterity/5,2))
			new /Condition/Poisoned(m, owner)
			m.effect("arrow-hit")
			m.noise('hit-1.wav', frequency = rand(0.7, 1.3))

projectile
	fireball
		icon_state = "fireball"
		pwidth = 20
		pheight = 16
		pixel_x = -6
		pixel_y = -5
		move_speed = 5
		damage = 15

		// make it use the MagicCombat object to deal damage
		hit(mob/m)
			MagicCombat.attack(owner, m, damage + round(owner.mind/10,2))

		movement()
			effect("flame", layer = layer - 1)
			..()
	Magic
		icon_state = "magic"
		pwidth = 20
		pheight = 16
		pixel_x = -6
		pixel_y = -5
		move_speed = 5
		damage = 15
		// make it use the MagicCombat object to deal damage
		hit(mob/m)
			MagicCombat.attack(owner, m, damage + round(owner.mind/10,2))

	lightning
		icon_state = "lightning"
		pwidth = 17
		pheight = 14
		pixel_x = -6
		pixel_y = -5

		move_speed = 7

		// make it use the MagicCombat object to deal damage
		hit(mob/m)
			new /Condition/Paralyzed(m, owner)

		movement()
			effect("static", layer = layer - 1)
			..()
