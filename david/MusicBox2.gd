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
	
