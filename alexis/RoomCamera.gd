extends Camera2D
@export var target: Node2D
@export var width : float = 640
@export var height : float = 360

@export var use_smooth: bool = true
@export var use_keep_down_speed = true

@export var lock_zone = Vector2(150, 230)
@export var dead_zone = Vector2(30, 20)

#new
@export var draw_debug = false
@export var top_offset = 40
@export var bottom_offset = 40
@export var target_offset = Vector2(0, 0)

@export var min_accel = 50
@export var min_speed = 100 # after accel (speed can be < 0 but should at least accelerate up to min_speed)
@export var decel_rate = 10

@export var SHOOT_DECAY_RATE:float = 3.0
@export var SHOOT_STRENGHT:int = 20

@export var HIT_STRENGTH:float = 4.0
@export var HIT_DECAY_RATE:float = 5.0
var shake_strength:float = 0.0


var hit_shake: bool = false
var shoot_shake: bool = false


### new
var vertical_speed = 0
var decelerate = false
var decel_speed = 0
var dist_to_target = Vector2.ZERO
var smooth_speed = Vector2(5,3)

var target_y = 0
var last_floor_y = 0
var y_offset = -70

var lock_y = true
var locked_y = 0

var boundaries = Rect2(0,0,0,0)
var boundaries_changed_flag = false

var last_target = null

var min_speed_y = 0

var was_grounded = true
var min_y_since_grounded = 0

func shake_on_shoot(direction: Vector2):
	offset = direction * SHOOT_STRENGHT
	shoot_shake = true

func shake_on_hit():
	hit_shake = true
	shake_strength += HIT_STRENGTH

func compute_camera_smooth(target, delta):
	var dist = target - global_position
	var c = smooth_speed * delta
	var move = dist * c
	return move


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.camera = self
	min_y_since_grounded = target.global_position.y
	
	var bus_idx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_idx, true)

func _draw():
	if(draw_debug):
		draw_bottom_line()
		draw_top_line()
		draw_target_y()
	
func draw_bottom_line():
	draw_line(Vector2(-width / 2, height / 2 - bottom_offset), Vector2(width / 2, height / 2 - bottom_offset), Color.RED, 3)

func draw_top_line():
	draw_line(Vector2(-width / 2, -height / 2 + top_offset), Vector2(width / 2, -height / 2 + top_offset), Color.RED, 3)

func draw_target_y():
	var y = (dist_to_target - target_offset).y
	draw_line(Vector2(-width / 2, y), Vector2(width / 2, y), Color.RED, 3)

func _physics_process(delta: float):
	
	Global.mouse_position = get_global_mouse_position()
	
	if not Global.player:
		return
	#var target = Global.player.global_position + Vector2.DOWN * y_offset
	var target = Global.player.global_position + target_offset
	if not last_target:
		last_target = target

	if draw_debug:
		queue_redraw()
	
	var player = Global.player
	var shake = false
	var is_grounded = player.is_on_floor()
	
	if boundaries_changed_flag:
		boundaries_changed_flag = false
		use_smooth = false
	else:
		use_smooth = true
	var move = target - global_position
	if use_smooth:
		move = calc_movement(global_position, target, delta)
	
	var goal = global_position + move
	
	var min_x = boundaries.position.x + width / 2
	var max_x = boundaries.position.x + boundaries.size.x + width / 2
	
	var min_y = floor(boundaries.position.y + height / 2)
	var max_y = floor(boundaries.position.y + boundaries.size.y + height / 2)
	
	var final = Vector2(clamp(goal.x, min_x, max_x), clamp(goal.y, min_y, max_y))
	
	#var final = Vector2(round(goal.x), round(goal.y))
	global_position = final
	last_target = final
	was_grounded = is_grounded
	
	global_position = final
	
	if shake:
		shake_with_delay()
	
	if shoot_shake:
		offset = lerp(offset, Vector2(), SHOOT_DECAY_RATE * delta)
		if offset == Vector2():
			shoot_shake = false
	if hit_shake:
		shake_strength = lerp(shake_strength, 0.0, HIT_DECAY_RATE * delta)
		offset = get_random_offset()
		if shake_strength == 0:
			hit_shake = false
	#print(target)
var last_move = Vector2.ZERO
var last_target2 = null
func calc_movement(position, target, delta):
	
	if last_target2 == null:
		last_target2 = target
	
	var dist = target - position
	dist_to_target = dist
	var dist_y = dist.y
	var move = Vector2.ZERO
	
	if last_move.y != 0 and sign(last_move.y) != sign(dist_y):
		vertical_speed = 0
	
	var target_move =  target - last_target2
	var target_speed_y = abs(target_move.y) / delta
	
	var dist_to_limit = get_dist_to_limit(dist, target_move)
	
	var required_speed = 0
	if dist_to_limit != null:
		if dist_to_limit < 0:
			move.y = -dist_to_limit
		if dist_to_limit > 0:
			var time_before_limit = dist_to_limit / target_speed_y
			required_speed = (target_speed_y - vertical_speed) / 2
			
			if sign(target_move.y) != sign(dist.y):
				required_speed = 0
			var accel = 0
			if required_speed > 0:
				accel = required_speed / time_before_limit * 1
				accel = max(accel, min_accel) * sign(dist.y)
				vertical_speed += accel * delta
		
	if target_move.y == 0 && dist.y != 0:
		if abs(vertical_speed) < min_speed:
			vertical_speed += min_accel * sign(dist.y) * delta

	#var c = abs(vertical_speed / 2) * delta * delta
	#var my = dist.y * c

	move.y =  vertical_speed * delta
	#move.y =  my
	if abs(move.y) > abs(dist.y):
		move.y = dist.y
			
	if abs(dist.y) < 0.1 && target_move.y == 0:
		move.y = dist.y

	#move.y = dist.y
	var camera_smooth = compute_camera_smooth(target, delta)
	move.x = camera_smooth.x
	last_move = move
	last_target2 = target
	return move
	
func get_dist_to_limit(dist: Vector2, target_move: Vector2):
	if target_move.y > 0:
		var real_limit = height / 2 - bottom_offset + target_offset.y
		return real_limit - dist.y
	if target_move.y < 0:
		var real_limit = height / 2 + top_offset - target_offset.y
		return real_limit - dist.y
	return null
	
	

func get_random_offset() -> Vector2:
	return Vector2(
		randf_range(-shake_strength, shake_strength),
		randf_range(-shake_strength, shake_strength)
	)
	
func set_boundaries(x, y, w, h):
	boundaries = Rect2(x, y, w, h)
	boundaries_changed_flag = true
	
func shake_with_delay():
	await get_tree().create_timer(0.1).timeout
	shake_on_hit()
