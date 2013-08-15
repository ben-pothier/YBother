mob
	verb
		Say(T as text)
			if(mute == 0)
				world << "[usr]: [T]"
			else
				alert("You're muted!!!","Muted")
				return