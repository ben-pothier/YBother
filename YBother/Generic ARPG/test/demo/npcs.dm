
// File:    demo\npcs.dm
// Library: Forum_account.ActionRpgFramework
// Author:  Forum_account
//
// Contents:
//   This file defines the NPCs. NPCs are invulnerable
//   mobs with simple AI (sometimes none) that the player
//   can interact with.

mob
	npc
		icon_state = "human-standing"
		invulnerable = 1
		base_speed = 5

		npc1
			interact(mob/m)

				// we call the ai_pause/play procs to make the mob
				// stop moving while you're interacting with him.
				ai_pause()

				// we omit the second argument, which makes this mob
				// the starting and ending point for the quest.
				m.quest_dialog(/Quest/KillThreeBlueOozes)
				ai_play()

			ai()
				// even though it's not an ability, we use cooldowns
				// to limit how often wander is called.
				if(!on_cooldown("wander"))
					wander(2)

			// when the NPC reaches the random tile they're walking
			// to, trigger their wander cooldown.
			moved_to()
				cooldown("wander", 40)

		npc2
			// this NPC is stationary so we override their ai() proc
			// to make them do nothing.
			ai()

			interact(mob/m)
				// this mob is only the starting point of the quest
				m.quest_dialog(/Quest/FindMyBrother, QUEST_START)

		npc3
			ai()

			interact(mob/m)
				// this mob is only the ending point of the quest
				m.quest_dialog(/Quest/FindMyBrother, QUEST_END)

		banker
			ai()

			interact(mob/m)
				m.banking()

		Guards
			wander_distance = 0
			base_speed = 3

			health = 60
			max_health = 60

			power = 8
			defense = 5

			abilities = list(new /Ability/EnemyAttack())

			ai()
				// run the default behavior which makes the guard
				// look for a target, move towards enemies, and
				// attack them.
				..()

				// if the target is dead, clear the target
				if(target && target.dead)
					target = null

				// if the guard doesn't have a target, make them
				// return to their starting point.
				if(!target && !path)
					move_to(locate(initial(x), initial(y), z))
			south_guard
				team = Constants.TEAM_SOUTH
			north_guard
				team = Constants.TEAM_NORTH
		Shopkeepers
			ai()
			var
				choice
			Armor_Shopkeeper
				New()
					..()

					// initialize the shopkeeper's inventory
					new /item/Equipment/Armor/shield(src)
					new /item/Equipment/Armor/armor(src)
					new /item/Equipment/Armor/helmet(src)




				interact(mob/m)

					choice = m.prompt("Hello, welcome to my shop. Would you like to browse some armor?", "Yes", "No")

					if(choice == "Yes")
						m.shopkeeper(src)
			Weapons_Shopkeeper
				New()
					..()

					// initialize the shopkeeper's inventory
					new /item/Equipment/Weapons/wand(src)
					new /item/Equipment/Weapons/bow(src)
					new /item/Equipment/Weapons/sword(src)
					new /item/Equipment/Weapons/dagger(src)




				interact(mob/m)

					choice = m.prompt("Hello, welcome to my weapons shop. Would you like to browse?", "Yes", "No")

					if(choice == "Yes")
						m.shopkeeper(src)

			Potions_Shopkeeper
				New()
					..()

					// initialize the shopkeeper's inventory
					new /item/Potions/Mana_Potions/mana_potion(src)
					new /item/Potions/Health_Potions/health_potion(src)
					new /item/Potions/Health_Potions/large_health_potion(src)
					new /item/Potions/Mana_Potions/large_mana_potion(src)



				interact(mob/m)

					choice = m.prompt("Hello, welcome to my potion brewery. Would you like to browse?", "Yes", "No")

					if(choice == "Yes")
						m.shopkeeper(src)
			Crafting_Shopkeeper
				New()
					..()

					// initialize the shopkeeper's inventory
					new /item/CraftingItems/ruby(src)
					new /item/CraftingItems/stick(src)
					new /item/CraftingItems/string(src)
					new /item/CraftingItems/iron_bar(src)


				interact(mob/m)

					choice = m.prompt("Hello, welcome to my store. Would you like to see some crafting materials?", "Yes", "No")

					if(choice == "Yes")
						m.shopkeeper(src)

Quest
	KillThreeBlueOozes
		name = "Blue Oozes"
		description = "The oozes have been getting closer and closer to town. Can you kill three blue oozes for me? That'll show 'em!"
		status = ""

		already_completed_message = "Thanks again for killing those blue oozes!"
		completion_message = "Wow, great job!"
		in_progress_message = "Keep at it, I know you can do it!"

		var
			// we keep a count of how many blue oozes you've killed
			count = 0

		// update the counter
		killed(mob/enemy/blue_ooze/b)
			if(istype(b))
				count += 1
				update()

		// update the quest's status
		update()
			..()

			if(count >= 3)
				complete = 1
				status("complete")
			else
				status("[count] / 3")

		// the quest is complete when you've killed at least 5 blue oozes
		is_complete()
			return count >= 3

	FindMyBrother
		name = "Find my Brother"
		description = "Can you find my brother and tell him that dinner is ready? I have no idea where he went."
		status = "complete"

		already_completed_message = "Thanks, his dinner was getting cold."
		completion_message = "Dinner's ready? Thanks for telling me!"
		in_progress_message = "Did you find him yet?"

		complete = 1
