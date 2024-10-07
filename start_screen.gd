extends CanvasLayer

var started = false

func _process(delta):
	if started:
		return
	if Input.is_anything_pressed():
		started = true
		#print('change scene')
		#get_tree().change_scene_to_file("res://main_edouard.tscn")
		$AnimationPlayer.play("fade")
