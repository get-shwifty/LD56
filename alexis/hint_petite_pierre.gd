extends Node2D

var unlocked_d := false
var unlocked_g := false
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

func can_display_hint(song: String) -> int:
	if not unlocked_d and song == "dbca":
		unlocked_d = true
	if not unlocked_g and song == "gbca":
		unlocked_g = true
	if not unlocked_f and song == "fbca":
		unlocked_f = true
	
	if unlocked_d and song in ["d", "db", "dbc", "dbca"]:
		return 2 if song == "dbca" else 1
	if unlocked_g and song in ["g", "gb", "gbc", "gbca"]:
		return 2 if song == "gbca" else 1
	if unlocked_f and song in ["f", "fb", "fbc", "fbca"]:
		return 2 if song == "fbca" else 1

	return 0
