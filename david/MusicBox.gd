extends Node


@export var audioA: AudioStreamPlayer2D = null
@export var audioB: AudioStreamPlayer2D = null
@export var audioC: AudioStreamPlayer2D = null
@export var audioD: AudioStreamPlayer2D = null

var players = {
	"A": audioA,
	"B": audioB,
	"C": audioC,
	"D": audioD
}

var last_player = null

var melodies = {
	"light": ['A', 'B', 'C', 'D'],
	"fly": ['C2', 'P', 'A'],
	"damage": ['A', 'C', 'B', 'P2', 'D']
}

var current_frame = 0
var interval_time = 10 # in frames
# time between notes that can be wrong before reset
# only for no keypress, and false key should be instantly wrong
var accepted_empty_error = 1 # in note frames
# accepted timing error on tempo
var accepted_timing_error = 1 # in note frames

var current_note_frames = []
var current_melodie_start = null

# Called when the node enters the scene tree for the first time.
func _ready():
	players = {
	"A": audioA,
	"B": audioB,
	"C": audioC,
	"D": audioD
	}


func _physics_process(delta):
	var key_pressed = false
	var current_note = "P"
	if Input.is_action_pressed("a"):
		current_note = "A"
		key_pressed = true
	elif Input.is_action_pressed("b"):
		current_note = "B"
		key_pressed = true
	elif Input.is_action_pressed("c"):
		current_note = "C"
		key_pressed = true
	elif Input.is_action_pressed("d"):
		current_note = "D"
		key_pressed = true
	
	if is_playing_music():
		if current_frame % interval_time != 0:
			current_frame += 1
			return
	if not is_playing_music() and current_note == 'P':
		return
	current_note_frames.append(current_note)
	current_frame += 1
	if current_note == "P" and last_player:
		#players[last_player].stop()
		last_player = null
	if current_note != "P" and last_player != current_note and last_player:
		pass
		#players[last_player].stop()
	if is_playing_music() and current_note != 'P':
		var player: AudioStreamPlayer2D = players[current_note]
		last_player = current_note
		if player.playing:
			return
		players[current_note].play()
		
	

func is_melodie_valid(melodie):
	var frame_index = 0
	var is_finished = false
	for pi in range(len(melodie)):
		var partition = melodie[pi]
		var note = partition[0]
		var length = 1
		if len(partition) > 1:
			print(partition)
			length = partition[1]
		var empty_error = 0
		var needed_frames = 60/interval_time * length
		var correct_counter = 0
		var max_len = min(len(current_note_frames) - frame_index, length*60/interval_time + accepted_timing_error)
		for i in range(max_len):
			var index = frame_index + i
			var frame_note = current_note_frames[index]
			if note != frame_note:
				if abs(correct_counter - needed_frames) < accepted_timing_error:
					frame_index = index
					break
				elif frame_note == "P":
					empty_error += 1
					if empty_error > accepted_empty_error:
						return false
				else:
					return false
			correct_counter += 1
		frame_index += max_len
		if pi == len(melodie) - 1:
			is_finished = true
	return [true, is_finished]
	
func is_playing_music():
	return len(current_note_frames) > 0
