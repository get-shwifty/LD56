extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	init()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func init():
	region_rect = Rect2(0, 0, 63, 32)
	
