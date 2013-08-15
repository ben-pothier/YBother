
// File:    player-crafting.dm
// Library: Forum_account.ActionRpgFramework
// Author:  Forum_account
//
// Contents:
//   This file defines the CraftingAbility type which
//   is a child of Ability and is used to create abilities
//   which consume a set of ingredients to produce a new
//   item.

CraftingAbility
	parent_type = /Ability

	var
		// this is an associative list that maps item
		// type to a quantity.
		list/materials

		// this is the type of the item produced
		product

		// this is an object you need to be standing near to
		// use the crafting ability.
		required_object

	/** proc
		set_crafting_xp(mob/m, e)
			m.crafting_xp = e
			check_crafting_level(m)
		gain_crafting_xp(mob/m, e)
			if(m.crafting_level != m.max_crafting_level)
				set_crafting_xp(m, m.crafting_xp + e)
				m.my_custom_hud.update()
		check_crafting_level(mob/m)
			while(m.crafting_xp >= m.crafting_xp_needed)
				m.crafting_level += 1
				crafting_level_up(m)
		crafting_level_up(mob/m)
			if(m.crafting_level == m.max_crafting_level)
				m << "You reached the maximum level for [m.crafting_class]!"
				m.crafting_xp = 0
				m.crafting_xp_needed = 0
			else
				m << "Your crafting has reached level [m.crafting_level]!"
				m.crafting_xp -= m.crafting_xp_needed
				m.crafting_xp_needed = (m.crafting_level*m.crafting_multiplier) + 50
				if(m.crafting_class == "Blacksmith")
					if(m.crafting_level == 5)
						m.abilities += new /CraftingAbility/MakeArmor
					if(m.crafting_level == 10)
						m.abilities += new /CraftingAbility/MakeHelmet
					if(m.crafting_level == 15)
						m.abilities += new /CraftingAbility/MakeLargeSword
	**/
	description()
		description = "Requires: "

		// build the list of materials needed
		var/comma = ""
		for(var/item_type in materials)
			var/quantity = materials[item_type]
			var/item/item = new item_type()

			description += "[comma][item.name] x[quantity]"
			comma = ", "

			item.loc = null

		return ..()

	// check to see if the player has the necessary materials.
	can_use(mob/user)

		// if the crafting ability requires a certain object,
		// make sure the player is near it.
		if(required_object)
			if(!user.is_near(required_object))
				user.not_near(required_object)
				return 0

		// make sure the player has the necessary materials.
		for(var/item_type in materials)
			var/quantity = materials[item_type]

			if(!user.has_item(item_type, quantity))
				user.missing_item(item_type, quantity)
				return 0

		return 1

	effect(mob/user)
		// consume the materials.
		for(var/item_type in materials)
			var/quantity = materials[item_type]
			user.consume_item(item_type, quantity)

		// create the resulting item.
		var/item/item = new product()

		// add it to the user's inventory
		user.get_item(item)
		//gain_crafting_xp(user,src.xp)
		// trigger the created_item event
		user.created_item(item)

