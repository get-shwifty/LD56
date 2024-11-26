extends Node2D

func on_song(song: String):
	if song.begins_with("dd") and song.length() <= 5:
		$RuneD.activate()
		$RuneD2.activate()
		if song.begins_with("ddbca") or song.begins_with("ddcab"):
			$CapsuleActivate.visible = true
		else:
			$CapsuleActivate.visible = false
	elif song.begins_with("d") and song.length() <= 5:
		$RuneD.activate()
		$RuneD2.deactivate()
		$CapsuleActivate.visible = false
	else:
		$RuneD.deactivate()
		$RuneD2.deactivate()
		$CapsuleActivate.visible = false
