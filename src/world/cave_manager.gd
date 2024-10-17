extends CanvasLayer
class_name CaveManager

@export var cover: Node2D = null
@onready var lights: Node2D = $Overlay/CanvasGroup/Lights


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.cave = self
	$Overlay/CanvasGroup/Dark.show()
	set_ratio(0)
	cover.get_node("DarkLayer").show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_ratio(ratio: float):
	set_shader_value(ratio)
	cover.modulate = Color(Color.WHITE, 1.0 - pow(ratio, 4))


func set_shader_value(value: float):
	var dark = $Overlay/CanvasGroup
	dark.material.set_shader_parameter("alpha", value);
