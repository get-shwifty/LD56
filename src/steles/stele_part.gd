extends Node2D

@export var song = "light"
@export var part = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_contact_area_entered(area):
	Global.memory.found_stele_part(song, part, self)
