extends Node2D

@export var action = "mushroom"

@onready var runes_sprites = get_children()
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
		runes_sprites[i].self_modulate = '00ffff'
		i += 1
	while i < len(song_activation):
		runes_sprites[i].self_modulate = 'ffffff'
		i += 1
		
func on_song_finished(name: String):
	pass
		
