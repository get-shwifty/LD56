extends Node2D

func on_song(song: String):
	if song == "":
		return
	
	if song.begins_with("f"):
		$RuneF.activate()
		if song.length() == 5 and song.ends_with("a"):
			$RuneA.activate()
			$RuneC.deactivate()
		elif song.length() == 5 and song.ends_with("c"):
			$RuneA.deactivate()
			$RuneC.activate()
		else:
			$RuneA.deactivate()
			$RuneC.deactivate()
	else:
		$RuneF.deactivate()
		$RuneA.deactivate()
		$RuneC.deactivate()
