extends Node2D

@export var auto_light = false
@export var fix_to_parent: bool = false
@export var amplitude: float = 0.05
@export var open_speed: float = 0.8

var target: Node2D = null
var ondulate = false

var counter = 0
var init = false

func _ready():
	$Light.scale = Vector2.ZERO
	show()
	if auto_light:
		$Light.scale = Vector2.ONE
	await get_tree().physics_frame
	target = get_parent()
	
	if not fix_to_parent:
		target.remove_child(self)
		Global.cave.lights.add_child(self)
	init = true
	
func _physics_process(delta):
	if not init: return
	if not target or not is_instance_valid(target): 
		queue_free()
		return
	if not fix_to_parent:
		var screen_cord = target.get_global_transform_with_canvas().origin
		global_position = screen_cord

func on():
	var tween = get_tree().create_tween()
	tween.tween_property($Light, "scale", Vector2.ONE, open_speed)
	await tween.finished
	ondulate = true
	
func off():
	var tween = get_tree().create_tween()
	tween.tween_property($Light, "scale", Vector2.ZERO, open_speed)
	await tween.finished
	ondulate = false
	
func animate(t: float):
	if not ondulate:
		return
	scale = Vector2.ONE + Vector2.ONE * cos(t) * amplitude
	

	
