extends Camera2D

@export var target: Node2D
@export var width : float = 768
@export var height : float = 432

func _physics_process(delta: float):
	var i = floor(target.global_position.x / width)
	var j = floor(target.global_position.y / height)
	global_position.x = (i + 0.5) * width
	global_position.y = (j + 0.5) * height
