@tool
extends Node2D
class_name Melody

@export var editor_compute_runes:bool:
	set(_value):
		if Engine.is_editor_hint():
			compute_runes()

@export var song := ""

var all_runes : Array[Rune] = []

func _ready() -> void:
	_get_all_runes()

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
		rune.position = Vector2(0, off_y)
		off_y -= 14
		song += rune.note
	
func on_song(played_song: String):
	for i in range(played_song.length(), -1, -1):
		if i == 0 or song.substr(0, i) == played_song:
			for j in range(all_runes.size()):
				if j < i:
					all_runes[j].activate()
				else:
					all_runes[j].deactivate()
			return played_song == song
