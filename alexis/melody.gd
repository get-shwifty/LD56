@tool
extends Node2D
class_name Melody

@export var editor_compute_runes:bool:
	set(_value):
		if Engine.is_editor_hint():
			compute_runes()

@export var song := ""
@export var is_hint := false

const RUNE_DIFF = 16
const TOP_OFFSET = 5
var all_runes : Array[Rune] = []

func _ready() -> void:
	compute_runes()

func _get_all_runes(this = self):
	if this == self:
		all_runes = []
	for child in this.get_children():
		if child is Rune:
			if Engine.is_editor_hint():
				if not is_editable_instance(this):
					set_editable_instance(this, true)
			all_runes.append(child)
		elif child.get_child_count() > 0:
			_get_all_runes(child)

func compute_runes():
	_get_all_runes()
	
	var off_y = 0
	song = ""
	for rune in all_runes:
		rune.is_hint = is_hint
		rune.position = Vector2(0, off_y)
		off_y -= RUNE_DIFF
		song += rune.note
	if has_node("Top"):
		$Top.position = Vector2(0, off_y - TOP_OFFSET)
		if is_hint:
			$Top.modulate.r = 100.0
			$Top.modulate.g = 100.0
			$Top.modulate.b = 100.0
	
func on_song(played_song: String):
	for i in range(song.length(), -1, -1):
		if i == 0 or played_song.ends_with(song.substr(0, i)): # old system was =
			for j in range(all_runes.size()):
				if j < i:
					all_runes[j].activate()
				else:
					all_runes[j].deactivate()
			if i == 0:
				return 0
			elif i == song.length():
				return 2
			else:
				return 1
