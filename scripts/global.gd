extends Node

var tp_steles = []
var player: Player = null
var map = null
var projectile_container: Node2D = null
var grotte_background_container: Node2D
var last_checkpoint = null


var request_music = null



var PLAYER = preload("res://src/player/note_player.tscn")

func _process(delta):
	if request_music:
		var stream = Settings.musics[request_music]
		var music_player = PLAYER.instantiate()
		music_player.music = stream
		player.add_child(music_player)
		request_music = null
		
