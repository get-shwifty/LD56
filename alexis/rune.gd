extends Node2D

const ANIM_DURATION = 0.150
var tween

func activate():
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property($Sprite2DActivated, "modulate:a", 1.0,
		(1.0 - $Sprite2DActivated.modulate.a) * ANIM_DURATION)

func deactivate():
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property($Sprite2DActivated, "modulate:a", 0.0,
		$Sprite2DActivated.modulate.a * ANIM_DURATION)
	
func on_song(song: String):
	if song.begins_with("d"):
		activate()
	else:
		deactivate()
