extends Node2D

func show_stell(name):
	for child in Global.memory.find_children(name):
		var tween = get_tree().create_tween()
		tween.tween_property(child, "modulate", Color.WHITE, 0.500)

func _on_show_shroom_body_entered(body: Node2D) -> void:
	show_stell("*Shroom")


func _on_show_firefly_body_entered(body: Node2D) -> void:
	show_stell("*Firefly?")


func _on_show_scolo_3_body_entered(body: Node2D) -> void:
	show_stell("*Scolo3")


func _on_show_scolo_2_body_entered(body: Node2D) -> void:
	show_stell("*Scolo2")


func _on_show_scolo_1_body_entered(body: Node2D) -> void:
	show_stell("*Scolo1")


func _on_show_boss_1_body_entered(body: Node2D) -> void:
	show_stell("*Boss1")


func _on_show_boss_2_body_entered(body: Node2D) -> void:
	show_stell("*Boss2")


func _on_show_boss_3_body_entered(body: Node2D) -> void:
	show_stell("*Boss3")
