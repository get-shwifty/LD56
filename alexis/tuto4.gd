extends Node2D

func on_song(song: String):
	if song.ends_with("acb"):
		$RuneA.activate()
		$RuneC.activate()
		$RuneB.activate()
	elif song.ends_with("ac"):
		$RuneA.activate()
		$RuneC.activate()
		$RuneB.deactivate()
	elif song.ends_with("a"):
		$RuneA.activate()
		$RuneC.deactivate()
		$RuneB.deactivate()
	else:
		$RuneA.deactivate()
		$RuneC.deactivate()
		$RuneB.deactivate()
