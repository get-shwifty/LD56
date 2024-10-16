extends CanvasGroup
class_name CaveManager

@onready var lights: Node2D = $Lights

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.cave = self
	$DarkLayer.show()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
