extends Node2D
class_name MusicBox3

signal on_song_played(song: String)

@export var audioA: Resource  = null
@export var audioB: Resource  = null
@export var audioC: Resource  = null
@export var AUDIO_PLAYER: Resource = null

@onready var area = $Area2D

@onready var players = {
	"A": audioA,
	"B": audioB,
	"C": audioC
}

var melodies = Settings.songs

var buffer = []
var buffer_frame = 0
var played = ""
var can_play = true
var buffer_interval = 10 # frames
var music_timout = 60*3 # frames
var music_frame = 0

var ignore_boss_music = false

func _physics_process(delta):
	if not Global.started:
		return
	if not can_play:
		return
	
	var cam = get_viewport().get_camera_2d()
	$Area2D.global_position = cam.global_position

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
	buffer.append(note)
	if buffer.size() > 30:
		buffer.pop_front()

	var song = "".join(buffer)
	on_song_played.emit(song)
	
	var areas = area.get_overlapping_areas()
	for a in areas:
		if a.get_parent().on_song(song) == true:
			buffer.clear()
