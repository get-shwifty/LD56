extends Node2D

func on_song(song: String):
	if song.begins_with("d"):
		$RuneD.activate()
	else:
		$RuneD.deactivate()
