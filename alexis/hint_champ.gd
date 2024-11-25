extends Node2D

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
	if song in [
		"d", "dc", "dca", "dcab",
		"dd", "ddc", "ddca", "ddcab"]:
		return true
	return false
