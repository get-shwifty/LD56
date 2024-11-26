extends Node2D

@export var DURATION = 0.300

func _ready():
	var tween = get_tree().create_tween().set_parallel(true).set_loops()
	tween.tween_property($Sprite, "modulate:a", 0.0, DURATION).from(0.5)
	tween.tween_property($Sprite, "frame", 4, DURATION).from(0)
