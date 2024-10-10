extends Node2D

@export var song_name = "ladder"

var is_open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Scolo/AnimatedSprite2D.play("default")
	$Scolo/AnimationPlayer.play("RESET")
	$Scolo/AnimatedSprite2D.speed_scale = 0
	
	#var shape = RectangleShape2D.new()
	#var old_shape = $LadderArea/CollisionShape2D.shape
	#shape.size = old_shape.size
	#$LadderArea/CollisionShape2D.shape = shape

func on_song(song: String):
	pass
		
func on_song_finished(name: String):
	if name == song_name:
		open()


func close():
	if not is_open:
		return
	$Scolo/AnimationPlayer.play("up")
	is_open = false
	
func open():
	$Timer.start()
	if is_open:
		return
	is_open = true
	$Scolo/AnimationPlayer.play("down")
	Global.request_music = "scolo"
	


func _on_timer_timeout():
	close()
