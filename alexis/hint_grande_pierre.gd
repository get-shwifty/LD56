extends Node2D

func on_song(song):
	if song.ends_with("bcc"):
		$RuneB.activate()
		$RuneC.activate()
		$RuneC2.activate()
	elif song.ends_with("bc"):
		$RuneB.activate()
		$RuneC.activate()
		$RuneC2.deactivate()
	elif song.ends_with("b"):
		$RuneB.activate()
		$RuneC.deactivate()
		$RuneC2.deactivate()
	else:
		$RuneB.deactivate()
		$RuneC.deactivate()
		$RuneC2.deactivate()
