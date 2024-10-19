extends Node2D
class_name SteleMemo

@export var parts: Array[Node2D] = []
@export var particles: Array[Node2D] = []

@onready var part_count = len(parts)
var found_count = 0



var found = []
# Called when the node enters the scene tree for the first time.
func _ready():
	for p in parts:
		p.hide()
	
func show_part(part: int, source):
	if part in found:
		return
	
	var p = parts[part-1]

	p.animate_found(source)
	found.append(part)
	
	if len(found) == len(parts):
		await get_tree().create_timer(0.5+0.4 - 0.1).timeout
		for particle in particles:
			particle.restart()
