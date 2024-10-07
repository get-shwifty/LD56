extends CanvasLayer

func _process(delta):
	if Global.started:
		return
	if Input.is_anything_pressed():
		$AnimationPlayer.play("fade")
		await $AnimationPlayer.animation_finished
		Global.started = true
