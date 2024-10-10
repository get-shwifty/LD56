extends CanvasLayer

var started = false

func _process(delta):
	if started:
		return
	if Input.is_anything_pressed():
		started = true
		$AnimationPlayer.play("fade")
