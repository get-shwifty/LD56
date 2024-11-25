extends Node2D

func on_song(song: String):
	if song.ends_with("fbcaa"):
		$RuneF.activate()
		$CapsuleActivate.visible = true
		$RuneA.activate()
	elif song.ends_with("fbca"):
		$RuneF.activate()
		$CapsuleActivate.visible = true
		$RuneA.deactivate()
	elif song.ends_with("fbc") or song.ends_with("fb"):
		$RuneF.activate()
		$CapsuleActivate.visible = false
		$RuneA.deactivate()
	elif song.ends_with("f"):
		$RuneF.activate()
		$CapsuleActivate.visible = false
		$RuneA.deactivate()
	else:
		$RuneF.deactivate()
		$CapsuleActivate.visible = false
		$RuneA.deactivate()
