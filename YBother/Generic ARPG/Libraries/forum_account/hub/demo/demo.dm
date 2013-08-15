
#define DEBUG

var
	// these are all of the medals you can earn.
	list/medal_list = list("Medal #1", "Other Medal", "Number Three")

world
	// this hub entry is needed for testing the medals and scores.
	hub = "Forumaccount.TestGame"
	hub_password = "BE9YTsqX1m859duH"

mob
	Login()
		..()

		src << "This demo contains some verbs you can use to test out all features of the library."
		src << "Go to http://www.byond.com/games/Forum_account/TestGame#tab=scores to see the scoreboard."

	verb
		// these three verbs test the medal procs.
		Test_Get_Medals()

			var/list/my_medals = client.GetMedals()

			world << "[key]'s Medals:"
			for(var/m in my_medals)
				world << " * [m]"
			world << ""

		Test_Add_Medal()
			var/medal = input(src, "Select a medal to award to yourself.") in medal_list

			world << "Awarding '[medal]' to [key]..."
			world << client.AddMedal(medal)
			world << "done."

		Test_Remove_Medal()
			var/medal = input(src, "Select a medal to remove from yourself.") in medal_list

			world << "Removing '[medal]' from [key]..."
			world << client.RemoveMedal(medal)
			world << "done."


		// this verb tests the score procs.
		Test_Scores()
			world << "Setting Level to 5"
			world << client.SetScore("Level", SET, 5)
			world << ""

			world << "Level MIN 4"
			world << client.SetScore("Level", MIN, 4)
			world << ""

			world << "Kills ADD 3"
			world << client.SetScore("Kills", ADD, 3)
			world << ""


		// this verb tests the server list proc.
		Test_Server_List()

			// get the list of servers...
			var/list/servers = world.GetServers("Exadv1", "SpaceStation13")

			world << "[servers.len] server\s"

			// and output some of the information about each one.
			for(var/Server/s in servers)
				world << "[s.url] ([s.players.len] player\s)"

				for(var/p in s.players)
					world << " * [p]"

				world << ""

		Test_Fans()
			var/list/fans = world.GetFans("Forumaccount", "Sidescroller")

			world << "[fans.len] fans:"
			for(var/f in fans)
				world << " * [f]"
