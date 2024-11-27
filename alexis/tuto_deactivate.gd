extends Node2D

func on_song(song: String):
	if song.begins_with("g") and song.length() <= 4:
		$RuneG.activate()
		if song == "gbca" or song == "gcab":
			$CapsuleActivate.visible = true
		else:
			$CapsuleActivate.visible = false
	else:
		$RuneG.deactivate()
		$CapsuleActivate.visible = false
