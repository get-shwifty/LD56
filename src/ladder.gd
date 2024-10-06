extends Node2D

@export var song_name = "ladder"

# Called when the node enters the scene tree for the first time.
func _ready():
	close()

func on_song(song: String):
	pass
		
func on_song_finished(name: String):
	if name == song_name:
		open()


func close():
	$Closed.show()
	$Open.hide()
	$LadderArea/CollisionShape2D.disabled = true
	
func open():
	$Closed.hide()
	$Open.show()
	$LadderArea/CollisionShape2D.disabled = false
	$Timer.start()


func _on_timer_timeout():
	close()
