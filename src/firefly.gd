extends Node2D

@onready var initial_position = global_position
@onready var MASK = preload("res://src/light_mask.tscn")
@onready var MASK_BACK = preload("res://src/light_mask_back.tscn")

var mask: Node2D = null
var mask_back: Node2D = null
var is_init = false
var counter = 0.0
# Called when the node enters the scene tree for the first time.
func init():
	if is_init:
		return
	mask = MASK.instantiate()
	mask_back = MASK_BACK.instantiate()
	get_parent().get_parent().get_node("Lights").add_child(mask)
	Global.grotte_background_container.add_child(mask_back)
	on()
	is_init = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	init()
	counter += delta
	var last_x = global_position.x
	global_position.x = initial_position.x + cos(counter) * 100
	var direction = sign(last_x - global_position.x)
	scale.x = direction
	mask.global_position = global_position
	mask_back.global_position = global_position

func on():
	$AnimatedSprite2D.play("on")
	mask.on()
	mask_back.on()
	
func off():
	$AnimatedSprite2D.play("off")
	mask.off()
	mask_back.off()
