extends Area2D

@export var play_once = false
@export var play_over = false
@export var music: Resource = null

@export var NOTE = preload("res://src/player/note_player.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	#print('activate:    ', area)
	#print('music:     ', self)
	
	if play_over:
		var player = NOTE.instantiate()
		player.music = music
		add_child(player)
		return
		
	Global.set_music(music)
