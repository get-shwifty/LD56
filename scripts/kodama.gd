extends Node2D

@onready var last_position = global_position
@onready var sprite_pos = $AnimatedSprite2D.position


var last_dir = 1

enum {IDLE, FOLLOW, FOLLOW_PAUSE}

var state = IDLE
var follow_path: NavigationGraph.Path
var idle_path: NavigationGraph.Path
var follow_pause_path: NavigationGraph.Path
var current_path: NavigationGraph.Path

var _follow_path_request: NavigationGraph.Path
var _state_request

var _pause_flag = true


var nav: NavigationGraph

var current_node_id: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	await get_tree().physics_frame
	nav = Global.graph
	nav.kodamas.append(self)
	shake_loop()
	
	sprite_pos += Vector2(randi_range(-6, 6), 0)
	$AnimatedSprite2D.position = sprite_pos
	
	current_node_id = nav.get_nav_node(global_position)

func generate_platform_walk():
	var nodes = nav.find_platform(current_node_id)
	var node = nodes.pick_random()
	
	var path = nav.gen_path(current_node_id, node)
	if path:
		return path
	
func shake_loop():
	while true:
		var time = randf_range(4.0, 10.0)
		await get_tree().create_timer(time).timeout
		
		if !nav or !current_path:
			continue
		if current_path.is_pause():
			shake()

func idle():
	#$AnimatedSprite2D.position = sprite_pos + Vector2(randi_range(-1, 1), 0) * 1
	if current_path:
		return
	if _pause_flag:
		var pause_time = randf_range(3.0, 12.0)
		var path = nav.gen_pause(current_node_id, pause_time)
		_set_idle_path(path)
		_pause_flag = false
	else:
		var close = nav.get_nav_in_radius(nav.nodes[current_node_id], 4)
		var g = close.pick_random()
		if g != current_node_id:
			var path = nav.gen_path(current_node_id, g)
			if path:
				_set_idle_path(path)
		_pause_flag = true
		
func tp(duration: float):
	var d = 0.1
	#await get_tree().create_timer(d).timeout
	get_tree().create_tween().tween_property(self, "modulate", Color(1,1,1,0), d)
	await get_tree().create_timer(duration / 4.0 - d).timeout
	get_tree().create_tween().tween_property(self, "modulate", Color(1,1,1,1), d)
	

func shake():
	var total = 0.1
	var c = 0
	while c < total:
		$AnimatedSprite2D.position = sprite_pos + Vector2(randi_range(-1, 1), 0) * 1
		c += 1/60.0
		await get_tree().physics_frame
	$AnimatedSprite2D.position = sprite_pos
	_pause_flag = !_pause_flag
	
func request_follow_path(path: NavigationGraph.Path):
	
	for i in range(len(path.trajs)):
		var t = path.trajs[i]
		if abs(t.move.y) > 0.1 or abs(t.move.x) > 1:
			var p = 0.15
			if randf() < p:
				path.replace_with_tp(i)
	
	if current_path and !current_path.finished and !current_path.is_stopped:
		current_path.request_stop()
		_follow_path_request = path
		_state_request = FOLLOW
	else:
		_set_follow_path(path)

func _set_follow_path(path):
	follow_path = path
	state = FOLLOW
	current_path = follow_path
	_pause_flag = true
	
func _set_idle_path(path):
	idle_path = path
	state = IDLE
	current_path = path
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func compute_next_pos(delta):
	var next_pos = global_position
	if current_path:
		if current_path.is_stopped or current_path.finished:
			current_node_id = current_path.get_next_node()
			check_next_path()
		if current_path:
			next_pos = current_path.get_next(delta)
			current_node_id = current_path.ids[current_path.current_index]
			if current_path.new_traj and current_path.new_traj.is_tp:
				tp(current_path.new_traj.duration)
	else:
		check_next_path()
	
	if state == IDLE:
		idle()
	return next_pos

func check_next_path():
	if _state_request:
		state = _state_request
		_state_request = null
		if _follow_path_request:
			_set_follow_path(_follow_path_request)
			_follow_path_request = null
	else:
		state = IDLE
		current_path = null
		
func get_next_node_id():
	if current_path:
		return current_path.get_next_node()
	return current_node_id

func _physics_process(delta):
	if not nav:
		return
		
	var pos = global_position
	var next = compute_next_pos(delta * 4)
	var move = next - pos
	
	global_position = next
	
	var walking = abs(move.y) < 0.01 and abs(move.x) > 0.1
	var direction = sign(move.x)
	
	var d = last_dir
	if abs(move.x) > 0.01:
		d = direction
	last_dir = d
	
	scale = Vector2(-d, 1)
	if walking:
		$AnimatedSprite2D.play("default")
	else:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 0
		
	last_position = pos
