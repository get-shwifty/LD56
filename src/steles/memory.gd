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
	if name not in steles:
		return null
	var stele: SteleMemo = steles[name]
	return stele

func found_stele_part(name: String, part: int, source):
	var stele = get_stele(name)
	if stele:
		stele.show_part(part, source)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
