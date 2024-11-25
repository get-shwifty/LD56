extends Node2D
class_name MusicBox3

signal on_song_played(song: String)

@export var audioA: Resource = null
@export var audioB: Resource = null
@export var audioC: Resource = null
@export var AUDIO_PLAYER: Resource = null

@onready var area = $Area2D
@onready var SAura = preload("res://alexis/aura.tscn")

@onready var SParticleNote = preload("res://alexis/note_particle2.tscn")
@onready var SParticleNotes = {
	"a": preload("res://alexis/rune_a.tscn"),
	"b": preload("res://alexis/rune_b.tscn"),
	"c": preload("res://alexis/rune_c.tscn"),
	"d": preload("res://alexis/rune_d.tscn"),
	"e": preload("res://alexis/rune_e.tscn"),
	"f": preload("res://alexis/rune_f.tscn"),
}

const notes_tones = {
	"a": ["G", 3],
	"b": ["A#", 3],
	"c": ["D", 4],
	"d": ["F", 3],
	"e": ["A", 3],
	"f": ["C", 4],
	"g": ["E", 4],
	"h": ["F", 4],
	"i": ["G", 4],
}

@onready var ALL_HINTS = [
	$StaticMemo/HintPetitePierre,
	$StaticMemo/HintGrandePierre,
	$StaticMemo/HintPlayer,
	$StaticMemo/HintEnable,
	$StaticMemo/HintTransform,
	$StaticMemo/HintMove,
]
@onready var ALL_DYN_HINTS = [
	$DynMemo/HintPetitePierre,
	#$DynMemo/HintGrandePierre,
	$DynMemo/HintPlayer,
	$DynMemo/HintChamp,
]

@onready var players = {
	"A": audioA,
	"B": audioB,
	"C": audioC
}

@onready var calculator: NoteValueCalculator = get_node("/root/NoteValue")
@onready var sampler: SamplerInstrument = $SamplerInstrumentGuitar

var melodies = Settings.songs

var buffer = []
var buffer_static_hint = []
var buffer_frame = 0
var played = ""
var can_play = true
var buffer_interval = 10  # frames
var music_timout = 60 * 3  # frames
var music_frame = 0

var ignore_boss_music = false

var dyn_hint = false
var has_to_release = -1.0

func _physics_process(delta):
	if not Global.started:
		return
	if not can_play:
		return

	var cam = get_viewport().get_camera_2d()
	$Area2D.global_position = cam.global_position

	#if Input.is_action_just_pressed("static_hint"):
		#if $StaticMemo.is_visible():
			#$StaticMemo.hide()
		#else:
			#buffer_static_hint.clear()
			#$StaticMemo.show()
			#for hint in ALL_HINTS:
				#hint.on_song("")


	if Input.is_action_just_pressed("dyn_hint_toggle"):
		dyn_hint = not dyn_hint

	if Input.is_action_pressed("dyn_hint") or dyn_hint:
		$DynMemo.show()
	else:
		$DynMemo.hide()

	if Input.is_action_just_pressed("alt1"):
		if buffer.size() > 0:
			if buffer[-1] in notes_tones:
				var note_tone = notes_tones[buffer[-1]]
				var value = calculator.get_note_value(note_tone[0], note_tone[1])
				var note_down = calculator.get_note_name(value - 2)
				var note_down_octave = calculator.get_note_octave(value - 2)
				sampler.glide(note_down, note_down_octave, 0.3)
	elif Input.is_action_just_pressed("alt2"):
		if buffer.size() > 0:
			if buffer[-1] in notes_tones:
				var note_tone = notes_tones[buffer[-1]]
				var value = calculator.get_note_value(note_tone[0], note_tone[1])
				var note_down = calculator.get_note_name(value + 2)
				var note_down_octave = calculator.get_note_octave(value + 2)
				sampler.glide(note_down, note_down_octave, 0.3)

	if has_to_release > 0.0:
		has_to_release -= delta
		if has_to_release > 0.2:
			if ( not Input.is_action_pressed("a")) and ( not Input.is_action_pressed("b")) and ( not Input.is_action_pressed("c")):
				has_to_release = 0.2
		elif has_to_release < 0.0:
			sampler.release()

	if Input.is_action_pressed("alt1") and Input.is_action_pressed("alt2"):
		if Input.is_action_just_pressed("a"):
			new_note("j")
		if Input.is_action_just_pressed("b"):
			new_note("k")
		if Input.is_action_just_pressed("c"):
			new_note("l")
	elif Input.is_action_pressed("alt1"):
		if Input.is_action_just_pressed("a"):
			new_note("d")
		if Input.is_action_just_pressed("b"):
			new_note("e")
		if Input.is_action_just_pressed("c"):
			new_note("f")
	elif Input.is_action_pressed("alt2"):
		if Input.is_action_just_pressed("a"):
			new_note("g")
		if Input.is_action_just_pressed("b"):
			new_note("h")
		if Input.is_action_just_pressed("c"):
			new_note("i")
	else:
		if Input.is_action_just_pressed("a"):
			new_note("a")
		if Input.is_action_just_pressed("b"):
			new_note("b")
		if Input.is_action_just_pressed("c"):
			new_note("c")

func new_note(note):
	if note in notes_tones:
		var note_tone = notes_tones[note]
		sampler.play_note(note_tone[0], note_tone[1])
		has_to_release = 100.0

	if $StaticMemo.is_visible():
		if note == "d" or note == "e" or note == "f":
			buffer_static_hint.clear()

		buffer_static_hint.append(note)
		if buffer_static_hint.size() > 8:
			buffer_static_hint.pop_front()
		for hint in ALL_HINTS:
			hint.on_song("".join(buffer_static_hint))
	else:
		if note in SParticleNotes:
			var res = SParticleNote.instantiate()
			var particle_note = SParticleNotes[note].instantiate()
			res.add_child(particle_note)
			res.position = %NoteSpawner.global_position
			Global.projectile_container.add_child(res)
			particle_note.activate()

		if note == "d" or note == "e" or note == "f":
			if not (buffer.size() == 1 and buffer[0] == "d"):
				buffer.clear()

		buffer.append(note)
		if buffer.size() > 8:
			buffer.pop_front()

		#if note == "d" or note == "e" or note == "f":
			#trigger_aura(global_position)

		notify_song()
		if buffer.is_empty():
			notify_song()

func notify_song():
	var song = "".join(buffer)
	on_song_played.emit(song)

	update_dyn_hint(song)

	var areas = area.get_overlapping_areas()
	for a: Area2D in areas:
		if a.get_parent().on_song(song) == true:
			buffer.clear()
			trigger_aura(a.global_position)

func update_dyn_hint(song: String):
	var visible_hints = []

	for hint in ALL_DYN_HINTS:
		hint.on_song(song)

		if hint.can_display_hint(song):
			hint.show()
			visible_hints.append(hint)
		else:
			hint.hide()

	if visible_hints.is_empty():
		$DynMemo/Nothing.show()
	else:
		$DynMemo/Nothing.hide()

		var N = visible_hints.size()
		var offset = 0.5 if N % 2 == 0 else 0.0
		for i in range(N):
			visible_hints[i].position.x = (i - (i / 2) - offset) * 22.0

func trigger_aura(position):
	var aura = SAura.instantiate()
	aura.position = position
	Global.projectile_container.add_child(aura)
