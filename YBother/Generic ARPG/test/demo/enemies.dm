
// File:    demo\enemies.dm
// Library: Forum_account.ActionRpgFramework
// Author:  Forum_account
//
// Contents:
//   This file defines an enemy. The enemy has a simple
//   AI routine and its own attack ability.

// The abilities in abilities.dm are explained better than this one.
Ability
	EnemyRangedAttack
		icon_state = "melee-attack"
		animation = "attacking"

		can_use(mob/user)
			if(user.on_cooldown("enemy-attack", "enemy-ranged-attack"))
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

			user.cooldown("enemy-attack", 40)
			user.cooldown("enemy-ranged-attack", 40)

			new /missile/EnemyArrow(user, user.target)
	EnemyAttack
		icon_state = "melee-attack"
		animation = "attacking"

		can_use(mob/user)
			if(user.on_cooldown("enemy-attack"))
				return 0

			if(!user.melee_target())
				return 0

			return ..()

		effect(mob/user)

			user.cooldown("enemy-attack", 40)

			var/mob/target = user.melee_target()

			if(target)
				PhysicalCombat.attack(user, target, user.power)
				new /Condition/Slowed(target, user)

				target.effect("punch")
				target.noise('hit-2.wav', frequency = rand(0.7, 1.3))

	EnemyPoisonAttack
		icon_state = "melee-attack"
		animation = "attacking"

		can_use(mob/user)
			if(user.on_cooldown("enemy-poison-attack"))
				return 0

			if(!user.melee_target())
				return 0

			return ..()

		effect(mob/user)

			user.cooldown("enemy-poison-attack", 160)

			var/mob/target = user.melee_target()

			if(target)
				new /Condition/Poisoned(target, user)
				target.effect("punch")
				target.noise('hit-2.wav', frequency = rand(0.7, 1.3))

mob
	enemy
		// when an enemy takes damage, make them target their attacker.
		took_damage(damage, mob/attacker, Combat/combat)
			..()

			if(!target)
				target = attacker
		// now we'll define a specific enemy
		blue_ooze
			base_state = "blue-ooze"
			icon_state = "blue-ooze-standing"
			shadow_state = "ooze-shadow"

			power = 4
			defense = 5
			resistance = 1

			health = 40
			max_health = 40

			base_speed = 1

			abilities = list(new /Ability/EnemyAttack())

			New()
				..()
				money = rand(1, 10)
				experience = 6
				original_locx = src.x
				original_locy = src.y
				original_locz = src.z

			// we override the died proc to give enemies a chance to drop items
			died()
				noise('splat.wav')
				spawn(600)
					new src.type(locate(src.original_locx,src.original_locy,src.original_locz))
					spawn(10)
						del(src)

				if(prob(50))
					if(prob(50))
						new /item/Potions/Health_Potions/health_potion(src)
					else
						new /item/Potions/Mana_Potions/mana_potion(src)
				if(prob(50))
					if(prob(50))
						new /item/Potions/Health_Potions/health_potion(src)
					else
						new /item/Potions/Mana_Potions/mana_potion(src)
				if(prob(35))
					new/item/CraftingItems/string(src)
				if(prob(30))
					new/item/CraftingItems/iron_bar(src)
				if(prob(20))
					new /item/CraftingItems/stick(src)
				if(prob(10))
					new /item/CraftingItems/ruby(src)

				..()

		// green oozes are just like blue ones except they have a poison attack too.
		green_ooze
			base_state = "green-ooze"
			icon_state = "green-ooze-standing"
			shadow_state = "ooze-shadow"

			power = 4
			defense = 5
			resistance = 2
			health = 40
			max_health = 40

			base_speed = 1

			abilities = list(new /Ability/EnemyAttack(), new /Ability/EnemyPoisonAttack())

			New()
				..()
				money = rand(3, 12)
				experience = 10
				original_locx = src.x
				original_locy = src.y
				original_locz = src.z

			// we override the died proc to give enemies a chance to drop items
			died()

				noise('splat.wav', frequency = 0.6)
				spawn(600)
					new src.type(locate(src.original_locx,src.original_locy,src.original_locz))
					spawn(10)
						del(src)
				if(prob(50))
					if(prob(50))
						new /item/Potions/Health_Potions/health_potion(src)
					else
						new /item/Potions/Mana_Potions/mana_potion(src)
				if(prob(50))
					if(prob(50))
						new /item/Potions/Health_Potions/health_potion(src)
					else
						new /item/Potions/Mana_Potions/mana_potion(src)
				if(prob(35))
					new/item/CraftingItems/string(src)
				if(prob(20))
					new /item/CraftingItems/stick(src)
				if(prob(10))
					new /item/CraftingItems/ruby(src)

				..()


		orange_ooze
			base_state = "orange-ooze"
			icon_state = "orange-ooze-standing"
			shadow_state = "ooze-shadow"

			power = 10
			defense = 20
			resistance = 15
			health = 80
			max_health = 80

			base_speed = 2

			abilities = list(new /Ability/EnemyAttack())

			New()
				..()
				money = rand(5, 15)
				experience = 15
				original_locx = src.x
				original_locy = src.y
				original_locz = src.z

			// we override the died proc to give enemies a chance to drop items
			died()
				noise('splat.wav')
				spawn(700)
					new src.type(locate(src.original_locx,src.original_locy,src.original_locz))
					spawn(10)
						del(src)
				if(prob(50))
					if(prob(50))
						new /item/Potions/Health_Potions/health_potion(src)
					else
						new /item/Potions/Mana_Potions/mana_potion(src)
				if(prob(50))
					if(prob(50))
						new /item/Potions/Health_Potions/health_potion(src)
					else
						new /item/Potions/Mana_Potions/mana_potion(src)
				if(prob(35))
					new/item/CraftingItems/string(src)
				if(prob(30))
					new/item/CraftingItems/iron_bar(src)
				if(prob(20))
					new /item/CraftingItems/stick(src)
				if(prob(10))
					new /item/CraftingItems/ruby(src)

				..()

		black_ooze
			base_state = "black-ooze"
			icon_state = "black-ooze-standing"
			shadow_state = "ooze-shadow"

			power = 20
			defense = 30
			resistance = 25
			health = 120
			max_health = 120

			base_speed = 2

			abilities = list(new /Ability/EnemyAttack(), new /Ability/EnemyRangedAttack())

			New()
				..()
				money = rand(15, 25)
				experience = 25
				original_locx = src.x
				original_locy = src.y
				original_locz = src.z

			// we override the died proc to give enemies a chance to drop items
			died()
				noise('splat.wav')
				spawn(1000)
					new src.type(locate(src.original_locx,src.original_locy,src.original_locz))
					spawn(10)
						del(src)
				if(prob(50))
					if(prob(50))
						new /item/Potions/Health_Potions/large_health_potion(src)
					else
						new /item/Potions/Mana_Potions/large_mana_potion(src)
				if(prob(50))
					if(prob(50))
						new /item/Potions/Health_Potions/large_health_potion(src)
					else
						new /item/Potions/Mana_Potions/large_mana_potion(src)
				if(prob(35))
					new/item/CraftingItems/string(src)
				if(prob(30))
					new/item/CraftingItems/iron_bar(src)
				if(prob(20))
					new /item/CraftingItems/stick(src)
				if(prob(10))
					new /item/CraftingItems/ruby(src)

				..()
		golden_ooze
			base_state = "golden-ooze"
			icon_state = "golden-ooze-standing"
			shadow_state = "ooze-shadow"

			power = 50
			defense = 70
			resistance = 70
			health = 250
			max_health = 250

			base_speed = 2.5

			abilities = list(new /Ability/EnemyAttack(), new /Ability/EnemyRangedAttack(), new /Ability/EnemyPoisonAttack())

			New()
				..()
				money = rand(40, 75)
				experience = 50
				original_locx = src.x
				original_locy = src.y
				original_locz = src.z

			// we override the died proc to give enemies a chance to drop items
			died()
				noise('splat.wav')
				spawn(1500)
					new src.type(locate(src.original_locx,src.original_locy,src.original_locz))
					spawn(10)
						del(src)
				if(prob(20))
					if(prob(30))
						new /item/Equipment/Weapons/wizard_wand(src)
					if(prob(30))
						new /item/Equipment/Weapons/large_sword(src)
					if(prob(30))
						new /item/Equipment/Weapons/elf_bow(src)

				..()