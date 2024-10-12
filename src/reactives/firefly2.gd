extends Node2D

var song_name = "firefly"
var counter = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	counter += delta * TAU / 2
	$AnimatedSprite2D.position.y = cos(counter) * 10

func on():
	$AnimatedSprite2D.play("on")
	$Timer.start()
	
func off():
	$AnimatedSprite2D.play("off")
	
func on_song(song: String):
	pass
		
func on_song_finished(name: String):
	if name == song_name:
		on()


func _on_timer_timeout():
	off()
