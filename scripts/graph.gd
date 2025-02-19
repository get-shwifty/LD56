extends Node2D
class_name NavigationGraph

@export var tilemap: TileMapLayer
@export var target: Node2D

var nodes: Array[Vector2i] = []
var obstacles: Array[Vector2i] = []
var edges: Array = []
var astar: NavAstar
var trajectories: Array = []

var selected_start: Vector2i
var selected_goal: int
var select_flag = false

var follow_flag = false

var path: Path

var JUMP_OVER = 16

@onready var pos_to_node = NodeIndex.new(tilemap)
@onready var pos_to_obstacle = NodeIndex.new(tilemap)

class NodeIndex:
	var offset: Vector2i
	var size: Vector2i
	var index = []
	func _init(tilemap: TileMapLayer):
		var used = tilemap.get_used_rect()
		self.offset = used.position
		self.size = used.size
		
		for x in range(self.size.x):
			self.index.append([])
			for y in range(self.size.y):
				self.index[x].append([])
				self.index[x][y] = null
	func add_node(node_id: int, node_pos: Vector2i):
		var pos = node_pos - offset
		self.index[pos.x][pos.y] = node_id
	
	func has_node(pos: Vector2i):
		var p = pos - offset
		return index[p.x][p.y] != null
		
	func get_node(pos: Vector2i):
		var p = pos - offset
		if p.x < 0 or p.x > self.size.x -1:
			return null
		if p.y < 0 or p.y > self.size.y -1:
			return null
		return index[p.x][p.y]

func _ready():
	generate_graph()
	
	var tpos = target.global_position
	var node_id = get_nav_node(tpos)
	var npos = nodes[node_id]
	target.global_position = tilemap.map_to_local(npos) / 2
	
	
func _physics_process(delta):
	follow_path(delta* 4)
	
func follow_path(delta: float):
	if not path:
		return
	if not follow_flag:
		return
	
	var next = path.get_next(delta)
	target.global_position = next
	
	if path.finished:
		path = null
		follow_flag = false
		queue_redraw()

func add_node(node: Vector2i):
	nodes.append(node)
	edges.append([])
	var id = len(nodes) - 1
	pos_to_node.add_node(id, node)
	return id
	
func add_obstacle(node: Vector2i):
	obstacles.append(node)
	var id = len(obstacles) - 1
	pos_to_obstacle.add_node(id, node)
	return id
	
func add_edge(from: int, to: int):
	edges[from].append(to)
	
func _draw():
	return
	for node in nodes:
		var pos = tilemap.map_to_local(node) / 2
		draw_rect(Rect2(pos, Vector2.ONE*3), Color.RED)
	for node in obstacles:
		var pos = tilemap.map_to_local(node) / 2
		draw_rect(Rect2(pos, Vector2.ONE*3), Color.BLUE)

	if selected_goal:
		var pos = tilemap.map_to_local(nodes[selected_goal]) / 2
		draw_rect(Rect2(pos, Vector2.ONE*5), Color.GREEN)
	
	if path:
		for i in range(len(path.ids)-1):
			var s = path.ids[i]
			var g = path.ids[i+1]
			var t = trajectories[s][g]
			draw_path(t, nodes[s])
			
func get_trajectory(from_id, to_id):
	var from = nodes[from_id]
	var to = nodes[to_id]
	var res = null
	var move = to - from
	if move.y < 0 or abs(move.x) > 1:
		res = UpJump.new(move)
	elif move.y > 0:
		res = Down.new(move)
	else:
		res = null
		res = Walk.new(move)
	return res
	

func draw_path(path: Trajectory, source: Vector2i):
	for i in range(path.duration * 10):
		var offset = path.fn(i / 10.0)
		var pos = tilemap.map_to_local(source) / 2
		var npos = pos + (offset * 16)
		draw_rect(Rect2(npos, Vector2.ONE*2), Color.CYAN)
	
func update_draw():
	queue_redraw()
	
func generate_graph():
	var cells = tilemap.get_used_cells()
	for cell in cells:
		var data = tilemap.get_cell_tile_data(cell)
		var is_ground = data.get_custom_data("ground")
		if is_ground:
			add_node(cell)
		var is_obstacle = data.get_custom_data("obstacle")
		if is_obstacle:
			add_obstacle(cell)
	for node_id in range(len(nodes)):
		findEdges(node_id)
		
	astar = NavAstar.new(trajectories)
	for id in range(len(nodes)):
		astar.add_point(id, nodes[id])
	for id in range(len(edges)):
		for n_id in edges[id]:
			astar.connect_points(id, n_id, false)
			var t = get_trajectory(id, n_id)
	
	for i in range(len(nodes)):
		trajectories.append([])
		for j in range(len(nodes)):
			trajectories[i].append(null)
	for id in range(len(edges)):
		for n_id in edges[id]:
			trajectories[id][n_id] = get_trajectory(id, n_id)
			
	
	
	update_draw()
	
class Trajectory:
	var start: Vector2
	var end: Vector2
	var duration: float
	
	func _init(move: Vector2):
		self.start = Vector2.ZERO
		self.end = move
		self.duration = max(abs(move.x), abs(move.y) * 0.8)
		
	func get_pos(time: float):
		pass
		
	func fn(x: float):
		pass
		#calc_trajectory()
	#
	#func calc_trajectory():
		#var diff_x = self.end.x - self.start.x
		#var diff_y = self.end.y - self.start.y
		#
		#
		
#class WalkTrajectory extends Trajectory:

class UpJump extends Trajectory:
	var h: float
	var g: float
	var a: float
	
	func _init(move: Vector2):
		super._init(move)
		self.g = -move.y
		self.h = 1
		if move.y < 0:
			var x_h = abs(move.x) / 1.5
			var y_h = abs(move.y) * 1.1
			self.h = max(x_h, y_h)
		if move.y > 0:
			self.h = 0.5
		if move.y == 0:
			self.h = abs(move.x) / 1.5
		
		self.a = (sqrt(-g/h + 1) + 1)
	
	func fn_y(t: float):
		return -(self.h * (-1 * pow((self.a * t / self.duration - 1), 2) + 1))
	
	func fn_x(t: float):
		return self.start.x + (self.end.x - self.start.x) * (t/ self.duration)
	
	func fn(t: float):
		return Vector2(self.fn_x(t), self.fn_y(t))
		
class Down extends Trajectory:
	
	func _init(move: Vector2):
		super._init(move)
		#if abs(move.y) > abs(move.x):
			#self.duration = max(abs(move.x), abs(move.y))
	func fn_y(t: float):
		return (self.end.y - self.start.y) * pow(t/self.duration, 2)
	func fn_x(t: float):
		return self.start.x + (self.end.x - self.start.x) * (t/ self.duration)
	func fn(t: float):
		return Vector2(self.fn_x(t), self.fn_y(t))
		
class Walk extends Trajectory:
	func fn_y(t: float):
		return self.start.y + (self.end.y - self.start.y) * (t/ self.duration)
	func fn_x(t: float):
		return self.start.x + (self.end.x - self.start.x) * (t/ self.duration)
	func fn(t: float):
		return Vector2(self.fn_x(t), self.fn_y(t))
	
func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton and event.pressed:
		#print("Mouse Click at: ", Global.mouse_position)
		var cell = tilemap.local_to_map(Global.mouse_position * 2)
		#tilemap.set_cell(cell, -1, Vector2i(0,0))
		var id = pos_to_node.get_node(cell)
		if id:
			on_click(id)
		
func on_click(id: int):
	selected_goal = id
	var start = get_nav_node(target.global_position)
	var ids = astar.get_id_path(start, selected_goal)
	var positions: Array[Vector2] = []
	var trajs: Array[Trajectory] = []
	
	for i in range(len(ids) - 1):
		var from = ids[i]
		var to = ids[i+1]
		trajs.append(trajectories[from][to])
		positions.append(tilemap.map_to_local(nodes[from]) / 2)
	positions.append(tilemap.map_to_local(nodes[selected_goal]) / 2)
		
	path = Path.new(ids, trajs, positions)
	follow_flag = true
	queue_redraw()
	
	
func findEdges(node_id: int):
	var node = nodes[node_id]
	for i in range(-5, 3):
		var res = findInRow(Vector2i(node.x, node.y - i), 4, 1)
		for r in res:
			add_edge(node_id, r)
			if i == 0:
				break
	for i in range(-5, 3):
		var res = findInRow(Vector2i(node.x, node.y - i), 4, -1)
		for r in res:
			add_edge(node_id, r)
			if i == 0:
				break
	var res = findInColumn(node, 4, 1)
	for r in res:
		add_edge(node_id, r)
	res = findInColumn(node, 4, -1)
	for r in res:
		add_edge(node_id, r)
	
func findInRow(cell: Vector2i, max_x: int, dir: int):
	var from = sign(dir) * 1
	var to = sign(dir) * max_x
	var res = []
	for i in range(from, to, sign(dir)):
		var n = Vector2i(cell.x + i, cell.y)
		#if tilemap.get_used_rect().has_point(n):
		var id = pos_to_node.get_node(n)
		if id != null:
			res.append(id)
	return res
	
func findInColumn(cell: Vector2i, max_x: int, dir: int):
	var from = sign(dir) * 1
	var to = sign(dir) * max_x
	var res = []
	for i in range(from, to, sign(dir)):
		var n = Vector2i(cell.x, cell.y + i)
		#if tilemap.get_used_rect().has_point(n):
		var id = pos_to_node.get_node(n)
		if id != null:
			res.append(id)
	return res

func get_nav_node(pos: Vector2):
	var cell = tilemap.local_to_map(pos * 2)
	var node_id = pos_to_node.get_node(cell)
	return node_id

class NavAstar extends AStar2D:
	var trajs: Array
	func _init(trajs: Array):
		self.trajs = trajs
		
	func _compute_cost(from_id, to_id):
		var t: Trajectory = self.trajs[from_id][to_id]
		var c = t.duration
		if abs(t.start.y - t.end.y) < 0.1:
			c *= 0.8
		if abs(t.start.x - t.end.x) > 2:
			c += 1.1
		return c
		
class Path:
	var ids: PackedInt64Array = []
	var trajs: Array[Trajectory] = []
	var positions: Array[Vector2] = []
	var current_index: int = 0
	var total_duration: float = 0
	var current_time: float = 0
	var time_limits: Array[float] = []
	var finished = false
	
	func _init(path: PackedInt64Array, trajs: Array[Trajectory], positions: Array[Vector2]):
		self.ids = path
		self.trajs = trajs
		self.positions = positions
		for t in self.trajs:
			self.total_duration += t.duration
			self.time_limits.append(self.total_duration)
	
	func get_next(delta: float):
		self.current_time += delta
		if self.current_time >= self.total_duration:
			finished = true
			return self.positions[-1]
		if self.current_time > self.time_limits[self.current_index]:
			self.current_index += 1
		var t = self.trajs[self.current_index]
		var last_limit = 0
		if self.current_index >= 1:
			last_limit = self.time_limits[self.current_index-1]
		var offset = t.fn(self.current_time - last_limit)
		return self.positions[self.current_index] + offset * 16
