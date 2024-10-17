extends Area2D

@export var direction = 1

enum Direction {LEFT, TOP, RIGHT, BOTTOM}
@export var inside_direction: Direction = Direction.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready():
	var coll: CollisionShape2D = $CollisionShape2D
	var shape: RectangleShape2D = coll.shape

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var colls = get_overlapping_areas()
	if colls:
		var coll = colls[0]
		var ratio = _calc_ratio(coll.global_position)
		Global.cave.set_ratio(ratio)
		
func _calc_ratio(position: Vector2):
	var coll: CollisionShape2D = $CollisionShape2D
	var shape: RectangleShape2D = coll.shape
	
	if inside_direction == Direction.LEFT:
		var start = coll.global_position.x + shape.get_rect().position.x
		var end = coll.global_position.x + shape.get_rect().position.x + shape.get_rect().size.x
		return 1.0 - smoothstep(start, end, position.x)
	if inside_direction == Direction.RIGHT:
		var start = coll.global_position.x + shape.get_rect().position.x
		var end = coll.global_position.x + shape.get_rect().position.x + shape.get_rect().size.x
		return smoothstep(start, end, position.x)
	if inside_direction == Direction.TOP:
		var start = coll.global_position.y + shape.get_rect().position.y
		var end = coll.global_position.y + shape.get_rect().position.y + shape.get_rect().size.y
		return 1.0 - smoothstep(start, end, position.y)
	if inside_direction == Direction.BOTTOM:
		var start = coll.global_position.y + shape.get_rect().position.y
		var end = coll.global_position.y + shape.get_rect().position.y + shape.get_rect().size.y
		return smoothstep(start, end, position.y)
