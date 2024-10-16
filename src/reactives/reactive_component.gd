extends Area2D

# -1 == forever
@export var active_time = 11
@export var song_condition = ""

signal activate
signal deactivate

var timer: Timer = null
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = active_time
	timer.connect("timeout", _on_timeout)
	await get_tree().physics_frame

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if not can_activate():
		return
	
	if active:
		timer.wait_time = active_time
		return
	_start()
	
func _start():
	active = true
	timer.start()
	activate.emit()

func _on_timeout():
	await get_tree().physics_frame
	if not can_activate():
		active = false
		deactivate.emit()
		
func can_activate():
	var colls = get_overlapping_areas()
	if not colls:
		return false
	
	var player_col = colls[0]
	
	if song_condition != "":
		var music = Global.music
		if music.active_songs.find(song_condition) < 0:
			return false
	
	return true
