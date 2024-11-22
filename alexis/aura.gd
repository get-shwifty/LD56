extends Node2D

@export var DURATION = 0.300

func _ready():
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property($Sprite, "modulate:a", 0.0, DURATION)
	tween.tween_property($Sprite, "frame", 5, DURATION)
	tween.chain().tween_callback($Sprite.queue_free)
