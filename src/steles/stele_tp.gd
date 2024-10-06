extends Node2D

@export var action = "home"

@onready var runes_sprites = $runes.get_children()
@onready var song_activation = Settings.songs[action]

func _ready():
	Global.tp_steles.append(self)

func on_song(song: String):
	var max_i = len(song_activation)
	var index = max_i
	while index > 0:
		if song.ends_with(song_activation.substr(0, index)):
			break
		index -= 1
	for i in range(index):
		runes_sprites[i].on()
	for i in range(index, max_i):
		runes_sprites[i].off()
		
func on_song_finished(name: String):
	if name == action:
		var player = Global.player
		player.teleport(global_position)
		
