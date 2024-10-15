extends Node2D

# IDLE, FIXED_MAP, GO_HOME, FIXED_HOME
var state = "IDLE"

var map_target: Node2D = null
var up_offset: float = 0
var up_speed: float = 40
@onready var initial_position  = self.global_position
# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == "IDLE":
		return
	if state == "FIXED_MAP":
		var up_vector = Vector2.UP * up_offset * up_speed
		var screen_cord = map_target.get_global_transform_with_canvas().origin
		global_position =  screen_cord + up_vector
		up_offset += delta

func animate_found(source: Node2D):
	state = "FIXED_MAP"
	map_target = source
	show()
	modulate = Color(Color.WHITE, 0)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(Color.WHITE, 1), 1)
	await tween.finished
	state = "IDLE"
	var tween2 = get_tree().create_tween()
	tween2.tween_property(self, "global_position", initial_position, 0.6)
	
