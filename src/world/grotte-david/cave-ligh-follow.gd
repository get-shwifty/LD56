extends Sprite2D

@export var target: Node2D = null
@export var dist = 0.05

var counter = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	counter += delta * TAU / 2
	#scale = Vector2.ONE + Vector2.ONE * cos(counter) * dist
	
	if target:
		global_position = target.global_position
