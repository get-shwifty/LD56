extends Node2D

var song_name = "luciole"

# Called when the node enters the scene tree for the first time.
func _ready():
	deactivate()


func on_song(song: String):
	pass
		
func on_song_finished(name: String):
	if name == song_name:
		activate()
		

func activate():
	show()
	$Platform/StaticBody2D/CollisionShape2D.disabled = false
	$Timer.start()
	
func deactivate():
	hide()
	$Platform/StaticBody2D/CollisionShape2D.disabled = true


func _on_timer_timeout():
	deactivate()
