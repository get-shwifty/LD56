extends Node2D

@export var keys: Array[DoorKey] = []

func _ready():
	for i in range(keys.size()):
		keys[i].on_collected.connect(key_collected.bind(i))

func key_collected(i):
	$Keys.get_child(i).show()
	keys[i].queue_free()


func has_all_keys():
	for child in $Keys.get_children():
		if not child.is_visible():
			return false
	return true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if has_all_keys():
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position:y", 100.0, 2.0).as_relative()
		tween.tween_callback(queue_free)
