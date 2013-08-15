
// File:    player-abilities.dm
// Library: Forum_account.ActionRpgFramework
// Author:  Forum_account
//
// Contents:
//   This file contains the Ability object, which has
//   vars and procs you can use to create custom attacks
//   and other special abilities.

Ability
	var
		name = ""
		tmp/icon = Constants.HUD_ICON
		tmp/icon_state = ""

		// this is just used for display purposes since
		// an ability may trigger any number of cooldowns
		cooldown = 0

		// this is used for display and is enforced by the
		// default can_use proc.
		mana_cost = 0

		// this is the animation flicked by the player when
		// the ability is used.
		tmp/animation = ""

		description = ""
		xp_multiplier = 0
		level = 1
		tmp/original_manaCost = 0
		xp = 0
		xp_needed = 0
		max_level = 100

	proc
		description()
			if(description)
				if(istype(src, /CraftingAbility))
					return "<b>[name]</b>\[Level: [level]]\n[description]\n[cooldown] tick cooldown"
				else if(istype(src, /item))
					return "<b>[name]</b>\n[description]"
				else
					return "<b>[name]</b>\[Level: [level]]\n[description]\n[cooldown] tick cooldown \[[xp]/[xp_needed] XP]"
			else
				return "<b>[name]</b>\[Level: [level]]\n[cooldown] tick cooldown \[[xp]/[xp_needed] XP]"
		set_icon_state(mob/owner, Ability/a)
			var/item/i
			if(owner.equipment)
				if(owner.equipment[TWO_HAND])
					i = owner.equipment[TWO_HAND]
					a.icon_state = "ability-button-[i.style]-attack"
				else if(owner.equipment[MAIN_HAND])
					i = owner.equipment[MAIN_HAND]
					a.icon_state = "ability-button-[i.style]-attack"
				else
					a.icon_state = "ability-button-unarmed-attack"
			else
				a.icon_state = "ability-button-unarmed-attack"
		can_use(mob/user, mob/target)
			if(user.mana < mana_cost)
				return 0

			return 1

		use(mob/user, mob/target)
			if(!can_use(user, target))
				return 0

			if(animation)
				user.state(animation, 10)

			user.lose_mana(mana_cost)

			effect(user, target)

		effect(mob/user, mob/target)
			gain_xp(1)

		gain_xp(e)
			if(level != max_level)
				set_xp(xp + e)

		set_xp(e)
			xp = e
			check_level()
		check_level()
			while(xp >= xp_needed)
				level += 1
				level_up()

		level_up()
			if(level == max_level)
				usr << "Your [name] has reached maximum level!"
				xp = 0
				xp_needed = 0
				set_manaCost(level*original_manaCost + mana_cost)
				set_cooldown(cooldown-(round(level/10)))
			else
				usr << "Your [name] has reached level [level]!"
				xp -= xp_needed
				xp_needed = (level*xp_multiplier)+15
				set_manaCost(level*original_manaCost + mana_cost)
				set_cooldown(cooldown-(round(level/10)))

		set_manaCost(mc)
			mana_cost = mc
		set_cooldown(cd)
			cooldown = cd
mob
	var
		list/key_bindings
		tmp/list/cooldowns
		list/abilities = list()

	key_down(k)
		..()

		if(!key_bindings)
			key_bindings = list()

		if(k in key_bindings)
			var/item/it
			var/Ability/ability
			if(istype(key_bindings[k], /Ability))
				ability = key_bindings[k]
			else
				it = key_bindings[k]
			if(ability && istype(ability))
				use_ability(ability)
			if(it && istype(it))
				it.use(usr)

	proc
		// binds an ability to a key
		bind_key(k, Ability/ability)

			if(!key_bindings)
				key_bindings = list()

			key_bindings[k] = ability

			if(ability_bar)
				ability_bar.refresh()

		// checks all general restrictions for ability usage
		// before invoking the ability
		use_ability(Ability/ability)

			if(dead)
				return 0

			ability.use(src)

		// triggers a cooldown or refreshes one that's still active
		cooldown(cooldown_name, cooldown_duration)

			if(!cooldowns)
				cooldowns = list()

			if(cooldowns[cooldown_name])
				cooldowns[cooldown_name] = max(cooldowns[cooldown_name], world.time + cooldown_duration * world.tick_lag)
			else
				cooldowns[cooldown_name] = world.time + cooldown_duration * world.tick_lag

		// each parameter is the name of a cooldown to check, this
		// proc returns 1 if any of the names are still on cooldown
		on_cooldown()

			if(!cooldowns)
				cooldowns = list()

			for(var/a in args)
				if(cooldowns[a] && cooldowns[a] > world.time)
					return 1

			return 0

		// each parameter is the name of a cooldown to clear.
		clear_cooldown()

			if(!cooldowns)
				cooldowns = list()

			for(var/a in args)
				cooldowns[a] = 0
