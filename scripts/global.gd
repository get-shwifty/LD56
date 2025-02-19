extends Node

var tp_steles = []
var player: Player = null
var map = null
var projectile_container: Node2D = null
var grotte_background_container: Node2D
var last_checkpoint = null
var camera = null
var mouse_position: Vector2

var request_music = null
var started = true
var memory = null

var speedrun_start_time = -1
var speedrun_time = -1

var PLAYER = preload("res://src/player/note_player.tscn")

func _process(delta):
	if request_music:
		var stream = Settings.musics[request_music]
		var music_player = PLAYER.instantiate()
		music_player.music = stream
		player.add_child(music_player)
		request_music = null
	
	if Input.is_action_just_pressed("speedrun"):
		get_tree().reload_current_scene()
		start_speedrun()

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

func start_speedrun():
	speedrun_start_time = Time.get_ticks_msec()
	speedrun_time = -1

func stop_speedrun():
	if speedrun_start_time > 0:
		speedrun_time = Time.get_ticks_msec() - speedrun_start_time
		speedrun_start_time = -1
