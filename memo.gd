extends Node2D

@export var parts: Array[Node2D] = []
@export var particles: Array[Node2D] = []

@onready var part_count = len(parts)
var found_count = 0

var found = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	for p in parts:
		p.hide()
		
	await get_tree().create_timer(2).timeout
	show_part(1)
	await get_tree().create_timer(2).timeout
	show_part(2)
	await get_tree().create_timer(2).timeout
	show_part(3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func show_part(part: int):
	var p = parts[part-1]
	p.show()
	p.modulate = Color(Color.WHITE, 0)
	var tween = get_tree().create_tween()
	tween.tween_property(p, "modulate", Color.WHITE, 1)
	particles[part-1].restart()
