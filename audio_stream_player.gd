extends AudioStreamPlayer

var boss_loop = preload("res://sounds/Musique-Boss-P2-Boucle.mp3")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_finished():
	if stream != boss_loop:
		boss_loop.loop = true
		stream = boss_loop
