extends Node2D

@export var note := ""
@export var activated := false

const ANIM_DURATION = 0.150
var tween

func ready():
	if activated:
		activate(true)
	else:
		deactivate(true)

func activate(fast = false):
	if tween:
		tween.kill()
	if fast:
		$Sprite2DActivated.modulate.a = 1.0
	else:
		tween = get_tree().create_tween()
		tween.tween_property($Sprite2DActivated, "modulate:a", 1.0,
			(1.0 - $Sprite2DActivated.modulate.a) * ANIM_DURATION)

func deactivate(fast = false):
	if tween:
		tween.kill()
	if fast:
		$Sprite2DActivated.modulate.a = 0.0
	else:
		tween = get_tree().create_tween()
		tween.tween_property($Sprite2DActivated, "modulate:a", 0.0,
			$Sprite2DActivated.modulate.a * ANIM_DURATION)
	
func on_song(song: String, fast = false):
	if song.begins_with(note):
		activate(fast)
	else:
		deactivate(fast)
