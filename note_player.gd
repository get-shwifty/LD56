extends AudioStreamPlayer2D

var music: Resource = null

# Called when the node enters the scene tree for the first time.
func _ready():
	stream = music
	play()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not playing:
		queue_free()
