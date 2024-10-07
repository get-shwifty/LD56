extends Node2D

@export var speed = 200

var ignore = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_body_entered(body):
	if ignore:
		return
	if body is CharacterBody2D:
		Global.player.teleport(Global.last_checkpoint.global_position)
		queue_free()
		return
	ignore = true
	await get_tree().create_timer(1).timeout
	queue_free()
