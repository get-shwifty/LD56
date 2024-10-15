extends Sprite2D

@export var amplitude: float = 0.05
@export var open_speed: float = 0.8

var ondulate = false


func on():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, open_speed)
	await tween.finished
	ondulate = true
	
func off():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, open_speed)
	await tween.finished
	ondulate = false
	
func animate(t: float):
	if not ondulate:
		return
	scale = Vector2.ONE + Vector2.ONE * cos(t) * amplitude
	
