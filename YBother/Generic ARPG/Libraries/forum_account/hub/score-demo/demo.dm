
world
	hub = "Forumaccount.TestGame"
	hub_password = "BE9YTsqX1m859duH"

// The /Score object creates a wrapper around the
// library's client.SetScore proc.
Score
	var
		client/client
		score
		data_type
		value

	New(client/c, s, dt = NUMERIC)
		client = c
		score = s
		data_type = dt

		spawn()
			value = client.GetScore(score, data_type)

	proc
		Add(x)
			value = client.SetScore(score, ADD, x, data_type)

		Subtract(x)
			value = client.SetScore(score, SUBTRACT, x, data_type)

		Max(x)
			value = client.SetScore(score, MAX, x, data_type)

		Min(x)
			value = client.SetScore(score, MIN, x, data_type)

		Set(x)
			value = client.SetScore(score, SET, x, data_type)

client
	var
		// we define these values as /Score objects which will
		// give us an easy way to update the player's scores.
		Score/hub_kills
		Score/hub_level

	New()
		..()

		// We only have to specify the name of the score
		// (ex: "Kills") here, we never need to put it
		// anywhere else in our code. This way we don't
		// get any bugs due to spelling the name of the
		// score incorrectly.
		hub_kills = new(src, "Kills", NUMERIC)
		hub_level = new(src, "Level", NUMERIC)

mob
	Stat()
		stat("mob values")
		stat("level", level)
		stat("kills", kills)

		stat("")
		stat("hub values")
		stat("highest level", client.hub_level.value)
		stat("kills", client.hub_kills.value)

	var
		level = 1
		kills = 0

	Login()
		..()

		src << "This demo shows you one way to abstract out the library's score procs to make it even easier to use."
		src << "Go to http://www.byond.com/games/Forum_account/TestGame#tab=scores to see the scoreboard."

	verb
		Level_Up()
			level += 1

			src << "You are now level [level]!"
			src << "Updating your hub score..."

			// We use the Max() operation because we want the
		 	// hub's scoreboard to keep track of the highest
		 	// level you've reached.
			client.hub_level.Max(level)

			src << "done."

		Add_Kills()
			var/k = rand(1, 4)

			src << "Adding [k] kill\s..."

			kills += k
			client.hub_kills.Add(k)

			src << "You have [client.hub_kills.value] kill\s."
