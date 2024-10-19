extends Node2D
class_name LightRegister

@export var active = true

var target: Node2D = null
var position_offset = Vector2.ZERO
var init = false

var last_pos = Vector2.ZERO

func _ready():
	if not active:
		hide()
		return
	position_offset = position
	var prev_pos = global_position
	var prev_scale = global_scale
	var prev_rotation = global_rotation
	await get_tree().physics_frame
	var parent = get_parent()
	target = Node2D.new()
	parent.add_child(target)
	target.global_position = prev_pos

	parent.remove_child(self)
	Global.cave.lights.add_child(self)
	
	global_scale = prev_scale * Settings.camera_zoom
	global_rotation = prev_rotation
	init = true
	show()
	
func _physics_process(delta):
	if not init: return
	if not target or not is_instance_valid(target): 
		queue_free()
		return
		
	var diff = Global.camera.global_position - last_pos
	last_pos = Global.camera.global_position
	var screen_cord = target.get_global_transform_with_canvas().origin
	global_position = screen_cord

	
