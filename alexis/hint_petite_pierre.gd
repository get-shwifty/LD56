extends Node2D

var unlocked_d := false
var unlocked_dd := false
var unlocked_f := false

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
	if not unlocked_d and song == "dbca":
		unlocked_d = true
	if not unlocked_dd and song == "ddbca":
		unlocked_dd = true
	if not unlocked_f and song == "fbca":
		unlocked_f = true
	
	if unlocked_d and song in ["d", "db", "dbc", "dbca"]:
		return true
	if unlocked_dd and song in ["dd", "ddb", "ddbc", "ddbca"]:
		return true
	if unlocked_f and song in ["f", "fb", "fbc", "fbca"]:
		return true

	return false
