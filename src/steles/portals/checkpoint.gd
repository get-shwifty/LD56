extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.last_checkpoint == self:
		$ActiveParticles.emitting = true


func _on_player_contact_area_entered(area):
	if Global.last_checkpoint == self:
		return
	Global.last_checkpoint = self
	$Explosion.restart()
