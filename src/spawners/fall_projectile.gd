extends RigidBody2D

@export var speed = 200
@export var sounds: Array[Resource] = []

var spawner = null
var ignore = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_body_entered(body):
	if ignore:
		return
	spawner.notify_projectil_end()
	if body is CharacterBody2D:
		Global.player.kill()
		hide()
		play_sound()
		return
	play_sound()
	ignore = true
	set_deferred("freeze", true)
	collision_layer = 0
	collision_mask = 0
	await get_tree().create_timer(0.2).timeout
	hide()

func play_sound():
	var sound = sounds.pick_random()
	$AudioStreamPlayer2D.stream = sound
	$AudioStreamPlayer2D.play()


func _on_audio_stream_player_2d_finished():
	queue_free()
