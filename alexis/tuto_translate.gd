extends Node2D

func on_song(song: String):
	if song == "ebca":
		$RuneE.activate()
		$RuneB.activate()
		$RuneC.activate()
		$RuneA.activate()
		var tween = get_tree().create_tween()
		tween.tween_property($"../Secret", "modulate:a", 0.0, 0.3)
	elif song == "ebc":
		$RuneE.activate()
		$RuneB.activate()
		$RuneC.activate()
		$RuneA.deactivate()
	elif song == "eb":
		$RuneE.activate()
		$RuneB.activate()
		$RuneC.deactivate()
		$RuneA.deactivate()
	elif song == "e":
		$RuneE.activate()
		$RuneB.deactivate()
		$RuneC.deactivate()
		$RuneA.deactivate()
	else:
		$RuneE.deactivate()
		$RuneB.deactivate()
		$RuneC.deactivate()
		$RuneA.deactivate()
