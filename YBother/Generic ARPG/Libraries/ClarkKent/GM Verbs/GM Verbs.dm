mob
	proc
		CheckBan()//checks to see if the new player is banned
			var/savefile/F = new("Bans.sav")
			var/checking
			F["[src.key]"] >> checking
			if(src.key == checking)
				src << "You have been banned!"
				del(src)
mob/admin/verb
	Boot(mob/M in world,reason as message|null)
		set category = "GM"
		set name = "Boot"
		set desc="(mob, \[reason]) Boot A Bastard"
		if(M == usr)
			usr << "<b>You can't boot yourself!"
			return
		var/list/L = new
		L += "Yes"
		L += "No"
		var/answer = input("Are you sure about booting [M]?") in L
		switch(answer)
			if("Yes")
				M << "You have been booted by [src] because [reason]"
				del(M)
			if("No")
				src << "You changed your mind, hehe!"
	Ban(mob/M in world)
		set category = "GM"
		if(M.key == "Drakstone")//put your key here
			alert("You can't ban the owner!","Can't ban him!")
			alert(M,"[usr] tried to ban you!","Attempted ban!")
			return
		if(M.key == usr.key)//prevents anyone from banning themselves
			alert("You can't ban yourself!","Can't ban yourself, n00b")
			return
		alert("Are You Sure You Want to Ban [M]?","Are You Sure?","Yes","No")
		if("Yes")
			alert("You banned [M]!")
			var/savefile/F = new("bans.sav")
			F["[M.key]"] += M.key
			M << "You have been banned by [usr.name]!"
			del(M)
	Unban()//Just what it says
		set category = "GM"
		unban()
	Mute(mob/M in world)//Mute that pain in the ass
		set category = "GM"
		if(M.mute == 0)
			alert("You muted [M]!","Mute a bastard!")
			M.mute = 1
		else
			alert("[M] is already muted!","Already Muted!")
			return
	Unmute(mob/M in world)//unmute a pain in the ass
		set category = "GM"
		if(M.mute == 1)
			alert("You unmuted [M]!","Unmute a player!")
			M.mute = 0
		else
			alert("[M] isn't muted!","Not muted!")
	Edit(obj/O as obj|mob|turf|area in view())//edit a variable in the world
		set category = "GM"
		set desc="(target) Edit a target item's variables"
		var/variable = input("Which var?","Var") in O.vars
		var/default
		var/typeof = O.vars[variable]
		var/dir
		if(variable == "GM")
			usr << "The Master GMs have disabled the var GM from changing. This is a GM variable."
			return
		if(isnull(typeof))
			usr << "Unable to determine variable type."

		else if(isnum(typeof))
			usr << "Variable appears to be <b>NUM</b>."
			default = "num"
			dir = 1

		else if(istext(typeof))
			usr << "Variable appears to be <b>TEXT</b>."
			default = "text"

		else if(isloc(typeof))
			usr << "Variable appears to be <b>REFERENCE</b>."
			default = "reference"

		else if(isicon(typeof))
			usr << "Variable appears to be <b>ICON</b>."
			typeof = "\icon[typeof]"
			default = "icon"

		else if(istype(typeof,/atom) || istype(typeof,/datum))
			usr << "Variable appears to be <b>TYPE</b>."
			default = "type"

		else if(istype(typeof,/list))
			usr << "Variable appears to be <b>LIST</b>."
			default = "cancel"

		else if(istype(typeof,/client))
			usr << "Variable appears to be <b>CLIENT</b>."
			default = "cancel"

		else
			usr << "Variable appears to be <b>FILE</b>."
			default = "file"

		usr << "Variable contains: [typeof]"
		if(dir)
			switch(typeof)
				if(1)
					dir = "NORTH"
				if(2)
					dir = "SOUTH"
				if(4)
					dir = "EAST"
				if(8)
					dir = "WEST"
				if(5)
					dir = "NORTHEAST"
				if(6)
					dir = "SOUTHEAST"
				if(9)
					dir = "NORTHWEST"
				if(10)
					dir = "SOUTHWEST"
				else
					dir = null
			if(dir)
				usr << "If a direction, direction is: [dir]"
		var/class = input("What kind of variable?","Variable Type",default) in list("text",
			"num","type","reference","icon","file","restore to default","cancel")

		switch(class)
			if("cancel")
				return

			if("restore to default")
				O.vars[variable] = initial(O.vars[variable])

			if("text")
				O.vars[variable] = input("Enter new text:","Text",\
					O.vars[variable]) as text

			if("num")
				O.vars[variable] = input("Enter new number:","Num",\
					O.vars[variable]) as num

			if("type")
				O.vars[variable] = input("Enter type:","Type",O.vars[variable]) \
					in typesof(/obj,/mob,/area,/turf)

			if("reference")
				O.vars[variable] = input("Select reference:","Reference",\
					O.vars[variable]) as mob|obj|turf|area in world

			if("file")
				O.vars[variable] = input("Pick file:","File",O.vars[variable]) \
					as file

			if("icon")
				O.vars[variable] = input("Pick icon:","Icon",O.vars[variable]) \
					as icon
	Play_Music(S as sound)//Play the music
		set category = "GM"
		world << sound(S)
	Stop_Music()//Stop playing the music
		set category = "GM"
		world << sound(null)
	Reboot()//this will reboot your server
		set name="Reboot"
		set category="GM"
		world << "<b><i><u><font face=arial><font color=blue><font size=4>Server Rebooting in 30 Seconds!-[usr]"
		sleep(300)
		world.Reboot()
	AdminTeleport(M as mob in world)//this will teleport you to any mob on the server including the ones you coded in
		set category = "GM"
		set name="GM Teleport"
		usr.x = M:x
		usr.y = M:y-1
		usr.z = M:z
		usr << "You go infront of [M]"
		view(6) << "<b>[usr] jumps out of your pocket!!"
	GM_Giving(mob/M in world)//give a user all of these GM verbs
		set category = "GM"
		world << "[usr] has made [M] a GM!"
		M.verbs += /mob/admin/verb/Ban
		M.verbs += /mob/admin/verb/Unban
		M.verbs += /mob/admin/verb/Mute
		M.verbs += /mob/admin/verb/Unmute
		M.verbs += /mob/admin/verb/Edit
		M.verbs += /mob/admin/verb/Play_Music
		M.verbs += /mob/admin/verb/Stop_Music
		M.verbs += /mob/admin/verb/Reboot
		M.verbs += /mob/admin/verb/AdminTeleport
		M.verbs += /mob/admin/verb/GM_Giving
		M.verbs += /mob/admin/verb/Remove_GM
		M.GM = 1
	Remove_GM(mob/M in world)//take those powers away again
		set category = "GM"
		if(M.GM == 1)
			world << "[M] is now non-GM!"
			M.verbs -= /mob/admin/verb/Ban
			M.verbs -= /mob/admin/verb/Unban
			M.verbs -= /mob/admin/verb/Mute
			M.verbs -= /mob/admin/verb/Unmute
			M.verbs -= /mob/admin/verb/Edit
			M.verbs -= /mob/admin/verb/Play_Music
			M.verbs -= /mob/admin/verb/Stop_Music
			M.verbs -= /mob/admin/verb/Reboot
			M.verbs -= /mob/admin/verb/AdminTeleport
			M.verbs -= /mob/admin/verb/GM_Giving
			M.verbs -= /mob/admin/verb/Remove_GM
			M.GM = 0
		if(M.GM < 1)
			alert("Unauthorized GM removal!","Can't do that!")
			return
		else
			alert("[M] isn't a GM!")
			return
	ChangeWorldName()//One reason to take away someones power is if they change the name to "Gayass Pansy Monkeys"
		set name = "Change World Name"
		set category = "GM"
		world.name = input("What is the new world name?","Change World Name",world.name)

	ChangeWorldStatus()//Just what it says
		set name = "Change World Status"
		set category="GM"
		world.status = input("What is the new world status?","Change World Status",world.status)

proc/unban()//DO NOT MODIFY THIS!!!.
    var/savefile/F = new("bans.sav")

    var/list/bans = F.dir

    var/list/menu = new()
    menu += bans

    var/result = input("Which key do you want to unban?", "Unbanning a key") in menu

    if(result)
        F.dir.Remove(result)
        alert("You unbanned [result]!")