extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Big.speed_scale = 0.3
	$Small.speed_scale = 0.3


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
