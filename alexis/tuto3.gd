extends Sprite2D

func on_song(song: String):
	if song.ends_with("e"):
		$RuneE.activate()
	else:
		$RuneE.deactivate()
