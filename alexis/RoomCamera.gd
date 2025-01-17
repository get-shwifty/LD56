extends Camera2D
@export var target: Node2D
@export var width : float = 768
@export var height : float = 432

@export var use_smooth: bool = true
@export var use_keep_down_speed = true

@export var lock_zone = Vector2(150, 230)
@export var dead_zone = Vector2(30, 20)

@export var SHOOT_DECAY_RATE:float = 3.0
@export var SHOOT_STRENGHT:int = 20

@export var HIT_STRENGTH:float = 4.0
@export var HIT_DECAY_RATE:float = 5.0
var shake_strength:float = 0.0


var hit_shake: bool = false
var shoot_shake: bool = false

var smooth_speed = Vector2(5,3)

var target_y = 0
var last_floor_y = 0
var y_offset = -70

var lock_y = false
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

func compute_min_move(target, move, delta):
	var dist = target - global_position
	var last_move_y = target.y - last_target.y
	if dist.y > 0:
		var limit = lock_zone.y + y_offset
		var dist_to_limit = limit - dist.y
		var buffer_zone = 70
		if dist_to_limit > 0 and dist_to_limit < buffer_zone:
			var ratio = dist_to_limit/buffer_zone
			var speed = (1-ratio) * last_move_y * 0.4
			move.y += speed
			move.y = min(move.y, dist_to_limit)
		if use_keep_down_speed:
			if dist.y < 1:
				min_speed_y = 0
			min_speed_y = max(min_speed_y, move.y)
			move.y = min_speed_y
	else:
		min_speed_y = 0
	return move

func compute_camera_smooth(target, delta):
	var dist = target - global_position
	var c = smooth_speed * delta
	var move = dist * c
	return move


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.camera = self
	min_y_since_grounded = target.global_position.y
	#
#func update_target_y():
	#var player = Global.player
	#var player_y = player.global_position.y
	#if player.is_on_floor():
		#target_y = player_y + y_offset
		#last_floor_y = player_y
	#elif player_y > last_floor_y:
		#var dist = player_y - last_floor_y
		#var ratio = 1.0
		#if dist < abs(y_offset):
			#ratio = dist / abs(y_offset) 
		#target_y = player_y + (1- ratio) * y_offset
	#


func _physics_process(delta: float):
	if not Global.player:
		return
	var target = Global.player.global_position + Vector2.DOWN * y_offset
	if not last_target:
		last_target = target
	#print(target)
	#var move = calc_movement(global_position, target, dead_zone, lock_zone, delta)
	#var dist = target - global_position
	#var move = move_camera(dist, delta)
	##print(move)
	#var goal = global_position + move
	#goal.x = floor(goal.x)
	#goal.y = floor(goal.y)
	#if goal.distance_to(target) < 2:
		#goal = target
	#
	#print()
	
	#var goal = target
	#update_target_y()
	

	
	var goal = global_position
	var move = Vector2.ZERO
	if use_smooth:
		move = compute_camera_smooth(target, delta)
		move = compute_min_move(target, move, delta)
		#print('move2 y: ', move.y)
		#goal += move
	
	var player = Global.player
	var shake = false
	var is_grounded = player.is_on_floor()
	var fall_dist = player.global_position.y - min_y_since_grounded
	if is_grounded and fall_dist > 200:
		shake = true
	if is_grounded:
		min_y_since_grounded = player.global_position.y
	if not is_grounded:
		min_y_since_grounded = min(min_y_since_grounded, player.global_position.y)
	
	var shroom = player.has_shroom_below()
	if shroom:
		shake = false
	if shroom and not lock_y:
		var dist = player.dist_to_shroom()
		lock_y = true
		locked_y = target.y + dist - 50
	elif not shroom:
		lock_y = false
	
	if lock_y and goal.y + move.y >= locked_y:
		#pass
		move.y = 0
		##print(locked_y)
	##goal.y = target_y 
	##goal.y += y_offset
	
	goal += move
	
	var min_x = boundaries.position.x + width / 2
	var max_x = boundaries.position.x + boundaries.size.x + width / 2
	
	var min_y = floor(boundaries.position.y + height / 2)
	var max_y = floor(boundaries.position.y + boundaries.size.y + height / 2)
	
	var final = Vector2(clamp(goal.x, min_x, max_x), clamp(goal.y, min_y, max_y))
	
	global_position = final
	
	if boundaries_changed_flag:
		boundaries_changed_flag = false
		use_smooth = false
	else:
		use_smooth = true

	last_target = final
	was_grounded = is_grounded
	
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
