extends Node2D

func on_song(song):
	if song.ends_with("dcab"):
		$RuneD.activate()
		$RuneC.activate()
		$RuneA.activate()
		$RuneB.activate()
	elif song.ends_with("dca"):
		$RuneD.activate()
		$RuneC.activate()
		$RuneA.activate()
		$RuneB.deactivate()
	elif song.ends_with("dc"):
		$RuneD.activate()
		$RuneC.activate()
		$RuneA.deactivate()
		$RuneB.deactivate()
	elif song.ends_with("d"):
		$RuneD.activate()
		$RuneC.deactivate()
		$RuneA.deactivate()
		$RuneB.deactivate()
	else:
		$RuneC.deactivate()
		$RuneA.deactivate()
		$RuneB.deactivate()
