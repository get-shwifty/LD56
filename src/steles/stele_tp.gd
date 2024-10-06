extends Node2D

@export var action = "home"

@onready var runes_sprites = $runes.get_children()
@onready var song_activation = Settings.songs[action]

func _ready():
	Global.tp_steles.append(self)

func on_song(song: String):
	var i = 0
	while i < len(song_activation):
		if i >= len(song):
			break
		if song[i] != song_activation[i]:
			break
		runes_sprites[i].on()
		i += 1
	while i < len(song_activation):
		runes_sprites[i].off()
		i += 1
		
func on_song_finished(name: String):
	if name == action:
		var player = Global.player
		player.teleport(global_position)
		
