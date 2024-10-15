extends Node

var tp_steles = []
var player: Player = null
var map = null
var projectile_container: Node2D = null
var grotte_background_container: Node2D
var last_checkpoint = null


var request_music = null
var started = true
var memory: Memory = null
var music: MusicBox = null

var PLAYER = preload("res://src/player/note_player.tscn")


func _ready():
	await get_tree().physics_frame
	var container = Node2D.new()
	get_tree().root.add_child(container)
	projectile_container = container

func _process(delta):
	if request_music:
		var stream = Settings.musics[request_music]
		var music_player = PLAYER.instantiate()
		music_player.music = stream
		player.add_child(music_player)
		request_music = null

func set_music(music):
	var map_m = map.get_node("Music")
	if map_m.stream == music:
		return
	map_m.stream = music
	map_m.play()
	
#func play_teleport(timeout):
	#var map_m: AudioStreamPlayer = map.get_node("Music")
	#map_m.stop()
	#request_music = "teleport"
	#await get_tree().create_timer(timeout).timeout
	#map_m.play()
