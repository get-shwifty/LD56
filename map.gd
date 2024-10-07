extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.map = self
	Global.projectile_container = $Projectiles
	#Global.grotte_background_container = $GrotteBackground/Mask
	$Music.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
