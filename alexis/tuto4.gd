extends Sprite2D

func on_song(song: String):
	if song.ends_with("bac") or song.ends_with("bacf"):
		$RuneB.activate()
		$RuneA.activate()
		$RuneC.activate()
	elif song.ends_with("ba"):
		$RuneB.activate()
		$RuneA.activate()
		$RuneC.deactivate()
	elif song.ends_with("b"):
		$RuneB.activate()
		$RuneA.deactivate()
		$RuneC.deactivate()
	else:
		$RuneB.deactivate()
		$RuneA.deactivate()
		$RuneC.deactivate()
