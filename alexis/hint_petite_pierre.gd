extends Node2D

func on_song(song):
	if song.ends_with("bca"):
		$RuneB.activate()
		$RuneC.activate()
		$RuneA.activate()
	elif song.ends_with("bc"):
		$RuneB.activate()
		$RuneC.activate()
		$RuneA.deactivate()
	elif song.ends_with("b"):
		$RuneB.activate()
		$RuneC.deactivate()
		$RuneA.deactivate()
	else:
		$RuneB.deactivate()
		$RuneC.deactivate()
		$RuneA.deactivate()

func can_display_hint(song: String):
	if song in [
		"d", "db", "dbc", "dbca",
		"dd", "ddb", "ddbc", "ddbca",
		"f", "fb", "fbc", "fbca"]:
		return true
	return false
