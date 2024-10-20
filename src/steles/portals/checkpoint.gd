extends Node2D

@export var default = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if default:
		Global.last_checkpoint = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ActiveParticles.emitting = Global.last_checkpoint == self


func _on_player_contact_area_entered(area):
	if Global.last_checkpoint == self:
		return
	Global.last_checkpoint = self
	$Explosion.restart()
	

func revive_anim():
	$Explosion.restart()
