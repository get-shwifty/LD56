extends Node2D

func on_song(song: String):
	if song.begins_with("e"):
		$RuneE.activate()
	else:
		$RuneE.deactivate()
