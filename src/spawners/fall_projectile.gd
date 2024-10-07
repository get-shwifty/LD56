extends Node2D

@export var speed = 200
@export var sounds: Array[Resource] = []


var ignore = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_body_entered(body):
	if ignore:
		return
	if body is CharacterBody2D:
		Global.player.kill()
		hide()
		play_sound()
		return
	play_sound()
	ignore = true
	await get_tree().create_timer(1).timeout
	hide()

func play_sound():
	var sound = sounds.pick_random()
	$AudioStreamPlayer2D.stream = sound
	$AudioStreamPlayer2D.play()


func _on_audio_stream_player_2d_finished():
	queue_free()
