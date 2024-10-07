extends CanvasLayer

func _process(delta):
	if Input.is_anything_pressed():
		print('change scene')
		get_tree().change_scene_to_file("res://main_edouard.tscn")
