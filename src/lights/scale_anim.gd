extends Node2D

@export var auto_light = false
@export var amplitude: float = 0.05
@export var open_speed: float = 0.8

@onready var initial_scale: Vector2 = global_scale
var ondulate = false

var counter = 0

func _ready():
	scale = Vector2.ZERO
	off()
	if auto_light:
		scale = initial_scale
		show()

func on():
	show()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", initial_scale, open_speed)
	await tween.finished
	ondulate = true
	
func off():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, open_speed)
	await tween.finished
	ondulate = false
	
func animate(t: float):
	if not ondulate:
		return
	scale = initial_scale + initial_scale * cos(t) * amplitude
	
func animate_open(t: float):
	scale = initial_scale * t
	
