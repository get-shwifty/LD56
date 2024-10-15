extends Sprite2D

@export var amplitude = 0.1

var counter = 0

func _physics_process(delta):
	counter += delta * TAU / 2
	scale = Vector2.ONE + Vector2.ONE * cos(counter) * amplitude
