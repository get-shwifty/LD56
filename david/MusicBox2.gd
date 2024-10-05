extends Node2D

@export var audioA: Resource  = null
@export var audioB: Resource  = null
@export var audioC: Resource  = null
@export var audioD: Resource = null
@export var AUDIO_PLAYER: Resource = null

@onready var players = {
	"A": audioA,
	"B": audioB,
	"C": audioC,
	"D": audioD
}

var melodies = {
	"light": ['A', 'B', 'C', 'D'],
	"fly": ['C', 'D', 'A'],
	"damage": ['A', 'C', 'B', 'A', 'D']
}

var buffer = []
var buffer_frame = 0
var played = []

var buffer_interval = 20 # frames
var music_timout = 60 # frames
var music_frame = 0

func _physics_process(delta):
	if Input.is_action_just_pressed("a"):
		buffer.append("A")
	if Input.is_action_just_pressed("b"):
		buffer.append("B")
	if Input.is_action_just_pressed("c"):
		buffer.append("C")
	if Input.is_action_just_pressed("d"):
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
			played = []
	
	
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
	played.append(note)

func check_finished_music():
	for name in melodies.keys():
		if is_music_finished(melodies[name]):
			print(name)
			played = []
			buffer = []
			buffer_frame = 0
			music_frame = 0

func is_music_finished(melodie):
	if len(melodie) != len(played):
		return false
	for i in range(len(melodie)):
		if melodie[i] != played[i]:
			return false
	return true
	
	
func _on_audio_finished():
	queue_free()  # Removes the AudioStreamPlayer2D from the scene
	
	
extends Sprite2D

@export var audioA: AudioStreamPlayer2D = null
@export var audioB: AudioStreamPlayer2D = null
@export var audioC: AudioStreamPlayer2D = null
@export var audioD: AudioStreamPlayer2D = null

@onready var players = {
	"A": audioA,
	"B": audioB,
	"C": audioC,
	"D": audioD
}

var melodies = {
	"light": ['A', 'B', 'C', 'D'],
	"fly": ['C', 'P', 'A'],
	"damage": ['A', 'C', 'B', 'P', 'D']
}

var buffer = []
var buffer_frame = 0
var played = []

var buffer_interval = 20 # frames
var music_timout = 60 # frames
var music_frame = 0

func _physics_process(delta):
	if Input.is_action_just_pressed("a"):
		buffer.append("A")
	if Input.is_action_just_pressed("b"):
		buffer.append("B")
	if Input.is_action_just_pressed("c"):
		buffer.append("C")
	if Input.is_action_just_pressed("d"):
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
			
	if len(played):
		music_frame += 1
		if music_frame > music_timout:
			print('played')
			print(played)
			played = []
	
	
func has_buffer():
	return len(buffer) > 0
	
func buffer_wait():
	return buffer_frame % buffer_interval != 0
	
func play_buffer():
	var note = buffer.pop_front()
	buffer_frame = 1
	players[note].play()
	played.append(note)
	
