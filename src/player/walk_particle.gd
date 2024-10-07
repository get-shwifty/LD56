extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var speed = randf_range(0.5, 1.6)
	$AnimatedSprite2D.speed_scale = speed
	$AnimatedSprite2D.play()
	$AnimationPlayer.play("fade")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animated_sprite_2d_animation_finished():
	queue_free()
