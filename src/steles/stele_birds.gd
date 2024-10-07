extends Node2D

signal on_played

@export var action = "mushroom"

@onready var runes_sprites = $runes.get_children()
@onready var song_activation: String = Settings.songs[action]

func _ready():
	Global.tp_steles.append(self)

func on_song(song: String):
	if (Global.player.global_position - global_position).length() > 100.0:
		return

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
	
	if index == max_i:
		$Stelle.open()
		on_played.emit()
	else:
		$Stelle.close()
		
func on_song_finished(name: String):
	if name == song_activation:
		get_tree().change_scene_to_file("res://src/end_scene.tscn")
		
