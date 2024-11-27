extends Node2D

func on_song(song: String):
	if song == "dbca":
		$RuneD.activate()
		$RuneB.activate()
		$RuneC.activate()
		$RuneA.activate()
	elif song == "dbc":
		$RuneD.activate()
		$RuneB.activate()
		$RuneC.activate()
		$RuneA.deactivate()
	elif song == "db":
		$RuneD.activate()
		$RuneB.activate()
		$RuneC.deactivate()
		$RuneA.deactivate()
	elif song == "d":
		$RuneD.activate()
		$RuneB.deactivate()
		$RuneC.deactivate()
		$RuneA.deactivate()
	else:
		$RuneD.deactivate()
		$RuneB.deactivate()
		$RuneC.deactivate()
		$RuneA.deactivate()
