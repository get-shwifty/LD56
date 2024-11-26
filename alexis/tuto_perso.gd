extends Node2D

var unlocked_f := false

func on_song(song: String):
	if song.ends_with("aab"):
		$RuneA.activate()
		$RuneA2.activate()
		$RuneB.activate()
	elif song.ends_with("aa"):
		$RuneA.activate()
		$RuneA2.activate()
		$RuneB.deactivate()
	elif song.ends_with("a"):
		$RuneA.activate()
		$RuneA2.deactivate()
		$RuneB.deactivate()
	else:
		$RuneA.deactivate()
		$RuneA2.deactivate()
		$RuneB.deactivate()

func can_display_hint(song: String):
	if not unlocked_f and song == "faab":
		unlocked_f = true
	
	if unlocked_f and song in ["f", "fa", "faa", "faab"]:
		return true

	return false
