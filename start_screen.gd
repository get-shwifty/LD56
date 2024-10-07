extends CanvasLayer

var started = false
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.player.is_teleport = true


func _process(delta):
	if started:
		return
	if Input.is_anything_pressed():
		$AnimationPlayer.play("fade")
		started = true
		await $AnimationPlayer.animation_finished
		Global.player.is_teleport = false
