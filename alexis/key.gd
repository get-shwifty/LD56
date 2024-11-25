extends Node2D
class_name DoorKey

signal on_collected

func _ready():
	$AnimatedSprite2D.play()

func _on_area_2d_body_entered(body: Node2D) -> void:
	on_collected.emit()
