extends Parallax2D

@export var player: Node2D

func _physics_process(delta: float):
	screen_offset.x = player.global_position.x
