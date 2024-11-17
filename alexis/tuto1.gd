extends Sprite2D

func on_song(song: String):
	if song.ends_with("d"):
		$RuneD.activate()
	else:
		$RuneD.deactivate()
