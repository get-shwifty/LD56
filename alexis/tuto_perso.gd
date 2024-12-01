extends Node2D

var unlocked_f := false

func on_song(song: String):
	if song.ends_with("Bb"):
		$RuneB.activate()
		$RuneC.activate()
		$RuneB2.activate()
	elif song.ends_with("B"):
		$RuneB.activate()
		$RuneC.activate()
		$RuneB2.deactivate()
	else:
		$RuneB.deactivate()
		$RuneC.deactivate()
		$RuneB2.deactivate()

func can_display_hint(song: String) -> int:
	if not unlocked_f and song == "fBb":
		unlocked_f = true
	
	if unlocked_f and song in ["f", "fB", "fBb"]:
		return 2 if song == "fBb" else 1

	return 0
