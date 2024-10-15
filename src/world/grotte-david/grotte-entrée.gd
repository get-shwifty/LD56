extends Area2D

@export var direction = 1

var start = 0
var end = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	var coll: CollisionShape2D = $CollisionShape2D
	var shape: RectangleShape2D = coll.shape
	#var rect: Rect2 = $CollisionShape2D.shape.get_rect()
	print(coll.global_position)
	print(coll.global_position + shape.get_rect().position)
	start = coll.global_position.x + shape.get_rect().position.x
	end = coll.global_position.x + shape.get_rect().position.x + shape.get_rect().size.x
	print(start)
	print(end)
	#rect.position = global_position + rect.position
	#print(rect.position)
	#print(rect.position.x - rect.size.x)
	#print(rect.position.x + rect.size.x)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var colls = get_overlapping_areas()
	if colls:
		var coll = colls[0]
		var alpha = smoothstep(start, end, coll.global_position.x)
		set_shader_value(alpha)


#func _on_area_entered(area):
	#print('player enter ', area.get_parent())
	#var tween = get_tree().create_tween().tween_method(set_shader_value, 0.0, 1.0, 1)
#
#
func set_shader_value(value: float):
	# in my case i'm tweening a shader on a texture rect, but you can use anything with a material on it
	var dark = get_parent().get_node('DarkSmoother')
	dark.material.set_shader_parameter("alpha", value);
	#var dark2 = get_parent().get_node("TileMapLayer")
	#dark2.modulate = Color(Color.WHITE, 1.0)
	
#
#
#func _on_area_exited(area):
	#var tween = get_tree().create_tween().tween_method(set_shader_value, 1.0, 0.0, 1)
