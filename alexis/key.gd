extends Node2D
class_name DoorKey

signal on_collected

func _ready():
	$AnimatedSprite2D.play()

func _on_area_2d_body_entered(body: Node2D) -> void:
	visible = false
	$AudioStreamPlayer2D.play()


func _on_audio_stream_player_2d_finished() -> void:
	on_collected.emit()
