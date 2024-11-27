extends Node2D

var unlocked_d := false
var unlocked_g := false

func on_song(song):
	if song.ends_with("cab"):
		$RuneC.activate()
		$RuneA.activate()
		$RuneB.activate()
	elif song.ends_with("ca"):
		$RuneC.activate()
		$RuneA.activate()
		$RuneB.deactivate()
	elif song.ends_with("c"):
		$RuneC.activate()
		$RuneA.deactivate()
		$RuneB.deactivate()
	else:
		$RuneC.deactivate()
		$RuneA.deactivate()
		$RuneB.deactivate()

func can_display_hint(song: String):
	if not unlocked_d and song == "dcab":
		unlocked_d = true
	if not unlocked_g and song == "gcab":
		unlocked_g = true
	
	if unlocked_d and song in ["d", "dc", "dca", "dcab"]:
		return true
	if unlocked_g and song in ["g", "gc", "gca", "gcab"]:
		return true

	return false
