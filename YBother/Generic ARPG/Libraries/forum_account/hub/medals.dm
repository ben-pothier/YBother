
// File:    medals.dm
// Library: Forum_account.Hub
// Author:  Forum_account
//
// Contents:
//   This file contains client procs that add/remove medals
//   and get a list of all medals the client has.

client
	var
		list/medals

	proc
		// This proc gives the player a medal. Its return values are:
		//
		//   0 - The hub could not be contacted and the medal was not awarded.
		//   1 - The player already had the medal
		//   2 - The player was successfully given the medal.
		//
		// If you're doing something like if(client.AddMedal("...")), the return
		// value will be true if the player, in the end, has the medal. The
		// distinction between 1 and 2 can be used to determine if the player
		// already had a medal or is getting it for the first time (since you
		// might want to do something special if they just got it, but not if
		// they already had it).
		AddMedal(medal)
			if(medals && (medal in medals))
				return 1

			var/result = world.SetMedal(medal, key)

			if(isnull(result))
				return 0

			if(medals)
				medals += medal

			if(result == 0)
				return 1

			return 2

		// These return values work the same as the ones for AddMedal.
		RemoveMedal(medal)
			if(medals && !(medal in medals))
				return 1

			var/result = world.ClearMedal(medal, key)

			if(isnull(result))
				return 0

			if(medals)
				medals -= medal

			if(result == 0)
				return 1

			return 2

		GetMedals()

			if(medals)
				return medals

			var/result = world.GetMedal("", src)

			if(isnull(result))
				return null

			medals = params2list(result)
			return medals
