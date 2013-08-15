
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
		tmp/name = ""
		tmp/icon = Constants.HUD_ICON
		tmp/icon_state = ""

		// this is just used for display purposes since
		// an ability may trigger any number of cooldowns
		tmp/cooldown = 0

		// this is used for display and is enforced by the
		// default can_use proc.
		tmp/mana_cost = 0

		// this is the animation flicked by the player when
		// the ability is used.
		tmp/animation = ""

		tmp/description = ""
		tmp/xp_multiplier = 0
		level = 1
		movespeed_mod = 0
		cooldown_mod = 0
		damage_mod = 0
		additional_effect = ""
		xp = 0
		xp_needed = 0
		max_level = 100

	proc
		description()
			if(description)
				return "<b>[name]</b>\[Level: [level]]\n[description]\n[cooldown] tick cooldown \[[xp]/[xp_needed] XP]"
			else
				return "<b>[name]</b>\[Level: [level]]\n[cooldown] tick cooldown \[[xp]/[xp_needed] XP]"

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
			gain_xp(1)

			effect(user, target)

		effect(mob/user, mob/target)

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
			else
				usr << "Your [name] has reached level [level]!"
				xp_needed = (level*xp_multiplier)+15
				xp = 0
			/**
			if(!usr.ability_mods)
				usr.ability_mods = list()
			if(usr.ability_mods[name])
				for(usr.ability_mods[name])
					damage_mod = usr.ability_mods[name][level]["damage_mod"]
					cooldown_mod = usr.ability_mods[name][level]["cooldown_mod"]
					additional_effect = usr.ability_mods[name][level]["additional_effect"]
					movespeed_mod = usr.ability_mods[name][level]["movespeed_mod"]
			else
				usr.ability_mods[name] = list()
				if(cmptext("Fireball",name))
					usr.ability_mods[name][level]["damage_mod"] = 0.15
			**/

		/**
			Working on creating a list of all abilities
			and storing each of their modifiers in there
			for each individual level.  When level_up() happens,
			increase that abilities modifiers by the stored ammount.
			Make sure that those modifiers are used in the abilities
			and possibly in the descriptions.
		**/

mob
	var
		list/key_bindings
		tmp/list/cooldowns
		list/abilities = list()
		list/ability_mods = list()

	key_down(k)
		..()

		if(!key_bindings)
			key_bindings = list()

		if(k in key_bindings)
			var/Ability/ability = key_bindings[k]

			if(ability && istype(ability))
				use_ability(ability)

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
