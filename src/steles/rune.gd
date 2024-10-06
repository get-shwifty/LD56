extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	off()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func off():
	play("off")
	
func on():
	play("on")
