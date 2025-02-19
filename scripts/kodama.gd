extends Node2D

@onready var last_position = global_position

var last_dir = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	var pos = global_position
	var move = pos - last_position
	
	var walking = abs(move.y) < 0.01 and abs(move.x) > 0.1
	var direction = sign(move.x)
	
	var d = last_dir
	if abs(move.x) > 0.01:
		d = direction
	last_dir = d
	
	scale = Vector2(-d, 1)
	if walking:
		$AnimatedSprite2D.play("default")
	else:
		$AnimatedSprite2D.stop()
		
	last_position = pos
