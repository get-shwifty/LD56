extends CanvasLayer
class_name Memory

@onready var firefly = $FireflyMemo
var steles = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.memory = self
	
	steles = {
		"light": $FireflyMemo,
		"mushroom": $MushroomMemo,
		"ladder": $LadderMemo
	}

func get_stele(name: String):
	var stele: SteleMemo = steles[name]
	return stele

func found_stele_part(name: String, part: int, source):
	print(name)
	get_stele(name).show_part(part, source)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
