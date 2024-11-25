extends Node2D

func on_song(song: String):
	if song.begins_with("f") and song.length() <= 5:
		$RuneF.activate()
		if song.begins_with("fbca") or song.begins_with("faab"):
			$CapsuleActivate.visible = true
			if song in ["fbcaa", "faaba"]:
				$RuneA.activate()
			else:
				$RuneA.deactivate()
		else:
			$CapsuleActivate.visible = false
			$RuneA.deactivate()
	else:
		$RuneF.deactivate()
		$CapsuleActivate.visible = false
		$RuneA.deactivate()
