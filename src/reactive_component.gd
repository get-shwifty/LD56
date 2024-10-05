extends Area2D
class_name Reactive

signal on_reaction()
@export var reactive_to_melody = ""

func melody_played(melody_name):
	if melody_name == reactive_to_melody:
		on_reaction.emit()
		return true
