extends Node2D
class_name Stelle

# Called when the node enters the scene tree for the first time.
func _ready():
	close()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func open():
	$StelleLumiere.show()
	
func close():
	$StelleLumiere.hide()
