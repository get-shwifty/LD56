extends TileMapLayer

func _ready():
	show()
	for area: Area2D in find_children("*", "Area2D", false):
		area.collision_layer = 0
		area.collision_mask = 128
		area.body_entered.connect(_on_area_2d_body_entered)
		area.body_exited.connect(_on_area_2d_body_exited)

func _on_area_2d_body_entered(body: Node2D) -> void:
	hide()

func _on_area_2d_body_exited(body: Node2D) -> void:
	show()
