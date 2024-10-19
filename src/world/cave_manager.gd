extends CanvasLayer
class_name CaveManager

@export var on: bool = false
@export var cover: Node2D = null
@onready var lights: Node2D = $Overlay/CanvasGroup/Lights


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.cave = self
	await get_tree().physics_frame
	$Overlay/CanvasGroup/Dark.show()
	set_ratio(0)
	cover.get_node("DarkLayer").show()
	
	if on:
		set_ratio(1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_ratio(ratio: float):
	#ratio = 1.0
	set_shader_value(ratio)
	cover.modulate = Color(Color.WHITE, 1.0 - pow(ratio, 2))


func set_shader_value(value: float):
	var dark = $Overlay/CanvasGroup
	dark.material.set_shader_parameter("alpha", value);
