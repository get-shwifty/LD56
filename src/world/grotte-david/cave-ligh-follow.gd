extends Node2D

@export var target: Node2D = null
@export var dist = 0.05

var counter = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().physics_frame
	if not target:
		target = Global.player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target:
		var screen_cord = target.get_global_transform_with_canvas().origin
		global_position = screen_cord
