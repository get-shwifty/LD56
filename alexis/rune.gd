@tool
extends Node2D
class_name Rune

@export var note := ""
@export var is_hint := false:
	set(is_hint_):
		$Hint.visible = is_hint_
		is_hint = is_hint_
var is_activated := false

const ANIM_DURATION = 0.150
var tween

func _ready():
	$Activated.show()
	deactivate(true)

func activate(fast = false):
	if tween:
		tween.kill()
	if fast:
		$Activated.modulate.a = 1.0
	else:
		tween = get_tree().create_tween()
		tween.tween_property($Activated, "modulate:a", 1.0,
			(1.0 - $Activated.modulate.a) * ANIM_DURATION)

func deactivate(fast = false):
	if tween:
		tween.kill()
	if fast:
		$Activated.modulate.a = 0.0
	else:
		tween = get_tree().create_tween()
		tween.tween_property($Activated, "modulate:a", 0.0,
			$Activated.modulate.a * ANIM_DURATION)

func on_song(song: String, fast = false):
	if song.ends_with(note):
		activate(fast)
	else:
		deactivate(fast)
