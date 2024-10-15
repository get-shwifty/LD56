extends Node2D

@export var back_light: Node2D = null
@export var front_light: Node2D = null

@export var target: Node2D = null

@onready var initial_position = global_position

var mask: Node2D = null
var mask_back: Node2D = null
var is_init = false
var counter = 0.0
var song_name = "light"
# Called when the node enters the scene tree for the first time.
func init():
	if is_init:
		return
	mask = MASK.instantiate()
	mask_back = MASK_BACK.instantiate()
	get_parent().get_parent().get_node("Lights").add_child(mask)
	Global.grotte_background_container.add_child(mask_back)
	off()
	is_init = true
	$AnimationPlayer.play("move")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	init()
	counter += delta
	var last_x = global_position.x
	global_position = target.global_position
	var direction = sign(last_x - global_position.x)
	scale.x = direction
	mask.global_position = global_position
	mask_back.global_position = global_position

func on():
	$AnimatedSprite2D.play("on")
	mask.on()
	mask_back.on()
	$Timer.start()
	
func off():
	$AnimatedSprite2D.play("off")
	mask.off()
	mask_back.off()
	
func on_song(song: String):
	pass
		
func on_song_finished(name: String):
	if name == song_name:
		on()


func _on_timer_timeout():
	off()
