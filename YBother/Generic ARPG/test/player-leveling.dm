
// File:    player-leveling.dm
// Library: Forum_account.ActionRpgFramework
// Author:  Forum_account
//
// Contents:
//   This file defines the mob's experience, level, and
//   money vars and has the procs to update these vars.

mob
	var
		plevel = 1
		experience = 0
		experience_needed = 5
		money = 0

	proc
		description(full_description = 0)
			if(full_description)
				return "<b>Level [plevel]</b>"
			else
				return "Level [plevel]"

		gain_experience(e)
			set_experience(experience + e)

		set_experience(e)
			experience = e
			if(xp_meter)
				xp_meter.update()

			check_level()

			if(info_box)
				info_box.refresh()

		check_level()
			while(experience >= experience_needed)
				plevel += 1
				level_up()

		level_up()
			experience -= experience_needed
			experience_needed = plevel * plevel * 5
			if(xp_meter)
				xp_meter.update()

			if(class == "Knight")
				if(plevel == 5)
					abilities += new /Ability/PowerSlash()
					src << "You gained the Power Slash ability!"
				gain_max_health(7)
				gain_max_mana(3)
				strength += 3
				vitality += 3
				mind += 1
				willpower += 1
				agility += 2
				dexterity += 2
				power += round(strength/4)
				defense += round(vitality/4)
				resistance += round(mind/10) + round(willpower/10)
			if(class == "Mage")
				if(plevel == 5)
					abilities += new /Ability/Stun()
					src << "You gained the Stun ability!"
				gain_max_health(3)
				gain_max_mana(7)
				strength += 1
				vitality += 1
				mind += 3
				willpower += 3
				agility += 2
				dexterity += 2
				power += round(mind/4)
				defense += round(vitality/10)
				resistance += round(mind/4) + round(willpower/4)
			if(class == "Ranger")
				if(plevel == 5)
					abilities += new /Ability/PoisonArrow()
					src << "You gained the Poison Arrow ability!"
				gain_max_health(5)
				gain_max_mana(5)
				strength += 2
				vitality += 1
				mind += 2
				willpower += 1
				agility += 3
				dexterity += 3
				power += round(dexterity/4)
				defense += round(vitality/6)
				resistance += round(mind/6) + round(willpower/8)
			health_meter.update()
			mana_meter.update()
			xp_meter.update()
			src << "You reached level [plevel]!"
			if(src.plevel == 5)
				src.num_slots += 1
				src.ability_bar.add_slot(src.num_slots, src)
				src << "You gained an ability slot!"
			else if(src.plevel == 30)
				src.num_slots += 1
				src.ability_bar.add_slot(src.num_slots, src)
				src << "You gained an ability slot!"

		gain_money(m)
			set_money(money + m)

		set_money(m)
			money = m

			if(info_box)
				info_box.refresh()
