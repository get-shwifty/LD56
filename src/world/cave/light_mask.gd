extends Node2D
@export var visual_scale = 1.0
@export var anim_speed_scale = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Visual.speed_scale = anim_speed_scale
	$Visual.play("default")
	$Visual.scale = Vector2.ONE * visual_scale
	off()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#print($Visual.global_scale)

func on():
	print('on')
	var tween = get_tree().create_tween()
	tween.tween_property($Visual, "scale", Vector2.ONE, 0.5)
	
func off():
	print('off')
	var tween = get_tree().create_tween()
	tween.tween_property($Visual, "scale", Vector2.ZERO, 0.5)
