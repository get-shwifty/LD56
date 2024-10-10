extends Node2D
@export var base_speed = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	$Big.speed_scale = base_speed
	$Small.speed_scale = base_speed
	off()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on():
	$Big.show()
	$Small.hide()
	$Big.play("default")
	
func off():
	$Big.hide()
	$Small.show()
	$Small.play("default")
