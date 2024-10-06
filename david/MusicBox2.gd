extends Node2D
class_name MusicBox

@export var audioA: Resource  = null
@export var audioB: Resource  = null
@export var audioC: Resource  = null
@export var audioD: Resource = null
@export var AUDIO_PLAYER: Resource = null

@onready var area = $Area2D

@onready var players = {
	"A": audioA,
	"B": audioB,
	"C": audioC,
	"D": audioD
}

var melodies = Settings.songs

var buffer = []
var buffer_frame = 0
var played = ""
var can_play = true
var buffer_interval = 10 # frames
var music_timout = 60 # frames
var music_frame = 0

func _physics_process(delta):
	if not can_play:
		return
	if Input.is_action_just_pressed("a") or (Input.is_action_pressed("sing") and Input.is_action_just_pressed("left")):
		buffer.append("A")
	if Input.is_action_just_pressed("b") or (Input.is_action_pressed("sing") and Input.is_action_just_pressed("up")):
		buffer.append("B")
	if Input.is_action_just_pressed("c") or (Input.is_action_pressed("sing") and Input.is_action_just_pressed("right")):
		buffer.append("C")
	if Input.is_action_just_pressed("d") or (Input.is_action_pressed("sing") and Input.is_action_just_pressed("down")):
		buffer.append("D")
	
	if has_buffer() and buffer_wait():
		music_frame = 0
		buffer_frame += 1
		return
	
	if has_buffer():
		play_buffer()
		music_frame = 0
	elif buffer_frame > 0:
		buffer_frame += 1
		if buffer_frame > buffer_interval:
			buffer_frame = 0
	check_finished_music()
	if len(played):
		music_frame += 1
		if music_frame > music_timout:
			notify_song("")
	
	
func has_buffer():
	return len(buffer) > 0
	
func buffer_wait():
	return buffer_frame % buffer_interval != 0
	
func play_buffer():
	var note = buffer.pop_front()
	buffer_frame = 1
	var music = players[note]
	var audio_player = AUDIO_PLAYER.instantiate()
	audio_player.music = music
	add_child(audio_player)
	notify_song(played + note)

func check_finished_music():
	for name in melodies.keys():
		if is_music_finished(melodies[name]):
			notify_song_finish(name)
			can_play = false
			await get_tree().create_timer(1).timeout
			can_play = true
			notify_song("")
			buffer = []
			buffer_frame = 0
			music_frame = 0

func is_music_finished(melodie):
	return played.ends_with(melodie)
	
func notify_song(list: String):
	played = list
	var areas = area.get_overlapping_areas()
	for a in areas:
		a.get_parent().on_song(played)
	for stele in Global.tp_steles:
		stele.on_song(played)
	
func notify_song_finish(name: String):
	var areas = area.get_overlapping_areas()
	for a in areas:
		a.get_parent().on_song_finished(name)
	for stele in Global.tp_steles:
		stele.on_song_finished(name)

func _on_area_2d_area_exited(area):
	area.get_parent().on_exit()
