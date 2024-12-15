extends Node2D
class_name MusicBox3

signal on_song_played(song: String)

const NB_NOTES = 6

@export var audioA: Resource = null
@export var audioB: Resource = null
@export var audioC: Resource = null
@export var AUDIO_PLAYER: Resource = null

@onready var areaReactives = $Area2DReactives
@onready var SAura = preload("res://alexis/aura.tscn")

@onready var SParticleNote = preload("res://alexis/note_particle2.tscn")
@onready var SParticleNotes = {
	"a": preload("res://alexis/melodies/runes/rune_a.tscn"),
	"b": preload("res://alexis/melodies/runes/rune_b.tscn"),
	"c": preload("res://alexis/melodies/runes/rune_c.tscn"),
	"d": preload("res://alexis/melodies/runes/rune_d.tscn"),
	"e": preload("res://alexis/melodies/runes/rune_e.tscn"),
	"f": preload("res://alexis/melodies/runes/rune_f.tscn"),
	"g": preload("res://alexis/melodies/runes/rune_g.tscn"),
	"h": preload("res://alexis/melodies/runes/rune_h.tscn"),
	"i": preload("res://alexis/melodies/runes/rune_i.tscn"),
	"n": preload("res://alexis/melodies/runes/rune_n.tscn"),
	"o": preload("res://alexis/melodies/runes/rune_o.tscn"),
}

const notes_tones = {
	"a": ["G", 3],
	"b": ["A#", 3],
	"c": ["D", 4],
	"f": ["F", 3],
	"e": ["A", 3],
	"d": ["C", 4],
	"i": ["D#", 4],
	"h": ["F", 4],
	"g": ["G", 4],
	"n": ["G", 3],
	"o": ["D", 3],
}

@onready var players = {
	"A": audioA,
	"B": audioB,
	"C": audioC
}

@onready var calculator: NoteValueCalculator = get_node("/root/NoteValue")
@onready var samplers: Array[SamplerInstrument] = [
	$SamplerInstrumentOriginal,
	$SamplerInstrumentGuitar,
	$SamplerInstrumentPiano,
	$SamplerInstrumentBass,
]
var current_sampler_index = 0
var sampler

var melodies = Settings.songs

var buffer = []
var buffer_frame = 0
var played = ""
var can_play = true
var buffer_interval = 10  # frames
var music_timout = 60 * 3  # frames
var music_frame = 0

var sign_direction = 1.0

var ignore_boss_music = false

var has_to_release = -1.0
var last_note_time := 0
const NOTE_MAX_DELAY = 5000

var visible_hints = []
var unlocked_hints = {}
var tween_dyn_hint : Tween = null
var can_show_dyn_hint = false
const DYN_HINT_DELAY = 1000

const CHORD_DELAY = 90 # 5 ticks is 5*16.67 = 83

func _ready():
	sampler = samplers[current_sampler_index]

func _physics_process(delta):
	if not Global.started:
		return
	if not can_play:
		return
		
	var cur_time = Time.get_ticks_msec()

	if buffer.size() > 0:
		var time_since_last_note = cur_time - last_note_time
		if time_since_last_note >= NOTE_MAX_DELAY:
			reset_buffer()
		elif time_since_last_note >= NOTE_MAX_DELAY - 500:
			hide_dyn_hint()
		elif time_since_last_note >= DYN_HINT_DELAY:
			show_dyn_hint()

	var cam = get_viewport().get_camera_2d()
	areaReactives.global_position = cam.global_position
	
	if Input.is_action_just_pressed("instrument"):
		current_sampler_index += 1
		if current_sampler_index >= samplers.size():
			current_sampler_index = 0
		if current_sampler_index != 0:
			$BackgroundMusic.stop()
		else:
			$BackgroundMusic.play()
		sampler = samplers[current_sampler_index]

	#if Input.is_action_just_pressed("alt1"):
		#if buffer.size() > 0:
			#if buffer[-1] in notes_tones:
				#var note_tone = notes_tones[buffer[-1]]
				#var value = calculator.get_note_value(note_tone[0], note_tone[1])
				#var note_down = calculator.get_note_name(value - 2)
				#var note_down_octave = calculator.get_note_octave(value - 2)
				#sampler.glide(note_down, note_down_octave, 0.3)
	#elif Input.is_action_just_pressed("alt2"):
		#if buffer.size() > 0:
			#if buffer[-1] in notes_tones:
				#var note_tone = notes_tones[buffer[-1]]
				#var value = calculator.get_note_value(note_tone[0], note_tone[1])
				#var note_down = calculator.get_note_name(value + 2)
				#var note_down_octave = calculator.get_note_octave(value + 2)
				#sampler.glide(note_down, note_down_octave, 0.3)

	if has_to_release > 0.0:
		has_to_release -= delta
		if has_to_release > 0.4:
			if ( not Input.is_action_pressed("a")) and ( not Input.is_action_pressed("b")) and ( not Input.is_action_pressed("c")):
				has_to_release = 0.4
		elif has_to_release < 0.0:
			sampler.release()

	if NB_NOTES == 5:
		if Input.is_action_just_pressed("a"):
			new_note("a")
		if Input.is_action_just_pressed("b"):
			new_note("b")
		if Input.is_action_just_pressed("c"):
			new_note("c")
		if Input.is_action_just_pressed("d"):
			new_note("d")
		if Input.is_action_just_pressed("e"):
			new_note("f")
	elif NB_NOTES == 6:
		if Input.is_action_pressed("alt1"):
			if Input.is_action_just_pressed("a"):
				new_note("d")
			if Input.is_action_just_pressed("b"):
				new_note("e")
			if Input.is_action_just_pressed("c"):
				new_note("f")
		else:
			if Input.is_action_just_pressed("a"):
				new_note("a")
			if Input.is_action_just_pressed("b"):
				new_note("b")
			if Input.is_action_just_pressed("c"):
				new_note("c")

	process_dyn_hint()

func reset_buffer():
	buffer.clear()
	can_show_dyn_hint = false
	notify_song()

func new_note(note):
	if note in notes_tones:
		var note_tone = notes_tones[note]
		sampler.play_note(note_tone[0], note_tone[1])
		#if note in ["d", "e", "f"]:
			#sampler.play_note(note_tone[0], note_tone[1] - 1)
		has_to_release = 5.0

	if note in SParticleNotes:
		var res = SParticleNote.instantiate()
		var particle_note = SParticleNotes[note].instantiate()
		res.add_child(particle_note)
		var local_pos = %NoteSpawner.position
		local_pos.x *= sign_direction
		res.position = to_global(local_pos)
		
		Global.projectile_container.add_child(res)
		particle_note.activate()

	var cur_time = Time.get_ticks_msec()
	if cur_time - last_note_time <= CHORD_DELAY and buffer.size() > 0:
		# manage chords
		var last_note = buffer[-1]
		var tuple = note + last_note
		match tuple:
			"bc", "cb":
				buffer.pop_back()
				note = "B"
			"ef", "fe":
				buffer.pop_back()
				note = "E"
			"hi", "ih":
				buffer.pop_back()
				note = "H"
			"kl", "lk":
				buffer.pop_back()
				note = "K"
			"am", "ma":
				buffer.pop_back()
				note = "M"
			"dn", "nd":
				buffer.pop_back()
				note = "N"
			"go", "og":
				buffer.pop_back()
				note = "G"
			"jp", "pj":
				buffer.pop_back()
				note = "P"
	
	last_note_time = cur_time
	#if buffer.size() == 0:
	can_show_dyn_hint = true
	buffer.append(note)
	auto_reset_melody()

	notify_song()
	if buffer.is_empty():
		notify_song()

func notify_song():
	var song = "".join(buffer)
	on_song_played.emit(song)

	for a: Reactive2 in areaReactives.get_overlapping_areas():
		if a.get_parent().has_method("on_song"):
			if a.get_parent().on_song(song) == 2 and a.trigger_feedback:
				continue
				#trigger_aura(a.global_position)
				#unlocked_hints[song] = a.get_parent().name
				#hide_dyn_hint()

	#for l in range(song.length(), 0, -1):
		#var subsong = song.substr(0, l)
	for hint: Melody in $DynMemo.get_children():
		if hint.on_song(song) == 2:
			can_show_dyn_hint = false
			unlocked_hints[hint.song] = hint.name
			var melody = hint.name
			#var rest = song.substr(l)
			notify_melody(melody, "")
			
		elif hint.on_song(song.substr(0, song.length() - 1)) == 2:
			can_show_dyn_hint = false
			unlocked_hints[hint.song] = hint.name
			var melody = hint.name
			#var rest = song.substr(l)
			notify_melody(melody, song[-1])
	if song == "":
		notify_melody("", "")

	update_dyn_hint(song)
	process_dyn_hint()

func notify_melody(melody, rest):
	for a: Reactive2 in areaReactives.get_overlapping_areas():
		if a.get_parent().has_method("on_melody"):
			if a.get_parent().on_melody(melody, rest) == true and a.trigger_feedback:
				trigger_aura(a.global_position)
				hide_dyn_hint()

func show_dyn_hint():
	if can_show_dyn_hint:
		can_show_dyn_hint = false
		if tween_dyn_hint:
			tween_dyn_hint.kill()
		tween_dyn_hint = get_tree().create_tween()
		tween_dyn_hint.tween_property($DynMemo, "modulate:a", 1.0, 0.3)

func hide_dyn_hint(fast = false):
	can_show_dyn_hint = false
	if tween_dyn_hint:
		tween_dyn_hint.kill()
	if fast:
		$DynMemo.modulate.a = 0.0
	else:
		tween_dyn_hint = get_tree().create_tween()
		tween_dyn_hint.tween_property($DynMemo, "modulate:a", 0.0, 0.5)

func auto_reset_melody():
	if buffer.size() > 8:
		buffer = buffer.slice(-8)
		can_show_dyn_hint = true

func update_dyn_hint(song: String):
	visible_hints = []

	for hint: Melody in $DynMemo.get_children():
		if hint.on_song(song) > 0 and hint.song in unlocked_hints:
			visible_hints.append(hint)
			hint.show()
		else:
			hint.hide()

func process_dyn_hint():
	var N = visible_hints.size()
	for i in range(N):
		visible_hints[i].position.x = i * 20

func trigger_aura(position):
	var aura = SAura.instantiate()
	aura.position = position
	Global.projectile_container.add_child(aura)

func _on_area_2d_reactives_area_entered(area: Area2D) -> void:
	buffer.clear()
	notify_song()
