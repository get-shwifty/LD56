extends Sprite2D

func on_song(song: String):
	if song.ends_with("fa"):
		$RuneF.activate()
		$RuneA.activate()
		$RuneC.deactivate()
	elif song.ends_with("fc"):
		$RuneF.activate()
		$RuneA.deactivate()
		$RuneC.activate()
	elif song.ends_with("f"):
		$RuneF.activate()
		$RuneA.deactivate()
		$RuneC.deactivate()
	else:
		$RuneF.deactivate()
		$RuneA.deactivate()
		$RuneC.deactivate()
