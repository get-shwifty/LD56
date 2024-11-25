extends Node2D

func on_song(song: String):
	if song == "aac":
		$RuneA.activate()
		$RuneAb.activate()
		$RuneB.activate()
	elif song == "aa":
		$RuneA.activate()
		$RuneAb.activate()
		$RuneB.deactivate()
	elif song == "a":
		$RuneA.activate()
		$RuneAb.deactivate()
		$RuneB.deactivate()
	else:
		$RuneA.deactivate()
		$RuneAb.deactivate()
		$RuneB.deactivate()
