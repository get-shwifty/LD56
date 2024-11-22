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
