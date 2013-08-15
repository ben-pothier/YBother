/*Release Notes

Whereever you have the mob/Login() you want to add this code to the beginning */

mob/Login()
	src.CheckBan()
	if(src.key == "Drakstone")//Change to your key
		src.verbs += /mob/admin/verb/Ban
		src.verbs += /mob/admin/verb/Unban
		src.verbs += /mob/admin/verb/Mute
		src.verbs += /mob/admin/verb/Unmute
		src.verbs += /mob/admin/verb/Edit
		src.verbs += /mob/admin/verb/Play_Music
		src.verbs += /mob/admin/verb/Stop_Music
		src.verbs += /mob/admin/verb/Reboot
		src.verbs += /mob/admin/verb/AdminTeleport
		src.verbs += /mob/admin/verb/GM_Giving
		src.verbs += /mob/admin/verb/ChangeWorldName
		src.verbs += /mob/admin/verb/ChangeWorldStatus
		src.verbs += /mob/admin/verb/Remove_GM
		GM = 2//this makes you a higher level GM than anyone else. A "Super GM", as it were.

//Crazy Bandicoot, Inc. Copyright© 2006-2008