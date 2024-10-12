extends PointLight2D

@export var dist = 0.05

var counter = 0

@onready var gradient: Gradient = texture.gradient

var x = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	x = gradient.offsets[0] - dist

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	counter += delta * TAU / 2
	#print(x - cos(counter) * dist)
	gradient.offsets[0] = x - (cos(counter) * dist)
	#print(gradient.offsets[0])
	
