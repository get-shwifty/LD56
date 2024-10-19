extends Node2D

@export var is_memo = false
@export var action: String = "light"
# IDLE, FIXED_MAP, GO_HOME, FIXED_HOME
var state = "IDLE"
@export var part = 1
var map_target: Node2D = null
var up_offset: float = 60
var scale_offset: float = 2.0
@onready var initial_position  = self.global_position
@onready var runes_sprites = $runes.get_children()
@onready var song_activation: String = Settings.songs[action]
# Called when the node enters the scene tree for the first time.
func _ready():
	if is_memo:
		hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	animate_part(Global.music.played)
	
	if state == "IDLE":
		return
	if state == "FIXED_MAP":
		var up_vector = Vector2.UP * up_offset
		var screen_cord = map_target.get_global_transform_with_canvas().origin
		global_position =  screen_cord + up_vector
		up_offset += delta

func animate_found(source: Node2D):
	state = "FIXED_MAP"
	map_target = source
	show()
	modulate = Color(Color.WHITE, 0)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(Color.WHITE, 1), 0.5)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(self, "scale", Vector2.ONE * scale_offset, 0.5)
	await tween.finished
	state = "IDLE"
	var tween3 = get_tree().create_tween()
	tween3.tween_property(self, "global_position", initial_position, 0.4)
	var tween4 = get_tree().create_tween()
	tween4.tween_property(self, "scale", Vector2.ONE, 0.6)
	
func animate_part(song: String):
	var max_i = len(song_activation)
	var index = max_i
	while index > 0:
		if song.ends_with(song_activation.substr(0, index)):
			break
		index -= 1
	for i in range(index):
		runes_sprites[i].on()
	for i in range(index, max_i):
		runes_sprites[i].off()


func _on_player_contact_area_entered(area):
	Global.memory.found_stele_part(action, part, self)
