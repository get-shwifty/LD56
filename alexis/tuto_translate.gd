extends Node2D

func on_song(song: String):
	if song.ends_with("ebca"):
		$RuneE.activate()
		$RuneB.activate()
		$RuneC.activate()
		$RuneA.activate()
	elif song.ends_with("ebc"):
		$RuneE.activate()
		$RuneB.activate()
		$RuneC.activate()
		$RuneA.deactivate()
	elif song.ends_with("eb"):
		$RuneE.activate()
		$RuneB.activate()
		$RuneC.deactivate()
		$RuneA.deactivate()
	elif song.ends_with("e"):
		$RuneE.activate()
		$RuneB.deactivate()
		$RuneC.deactivate()
		$RuneA.deactivate()
	else:
		$RuneB.deactivate()
		$RuneC.deactivate()
		$RuneA.deactivate()
