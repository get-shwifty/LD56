@tool
extends Node2D
class_name Melody

@export var editor_compute_runes:bool:
	set(_value):
		if Engine.is_editor_hint():
			compute_runes()

@export var song := ""
@export var with_feedback := true

func compute_runes():
	var off_y = 0
	song = ""
	for child in get_children():
		if child is Rune:
			child.position.y = off_y
			off_y -= 14
			song += child.note
	
func on_song(played_song: String):
	for i in range(played_song.length(), -1, -1):
		if i == 0 or song.substr(0, i) == played_song:
			var j = 0
			for child in get_children():
				if child is Rune:
					if j < i:
						child.activate()
					else:
						child.deactivate()
					j += 1
			return with_feedback and played_song == song
