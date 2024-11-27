extends Node2D

func on_song(song):
	if song == "dcab":
		$RuneD.activate()
		$RuneC.activate()
		$RuneA.activate()
		$RuneB.activate()
	elif song == "dca":
		$RuneD.activate()
		$RuneC.activate()
		$RuneA.activate()
		$RuneB.deactivate()
	elif song == "dc":
		$RuneD.activate()
		$RuneC.activate()
		$RuneA.deactivate()
		$RuneB.deactivate()
	elif song == "d":
		$RuneD.activate()
		$RuneC.deactivate()
		$RuneA.deactivate()
		$RuneB.deactivate()
	else:
		$RuneD.deactivate()
		$RuneC.deactivate()
		$RuneA.deactivate()
		$RuneB.deactivate()
