@tool
extends Node2D

const W = 640.0
const H = 360.0


class Zone:
	var id: int
	var x: int
	var y: int
	var w: int
	var h: int
	
	func _to_string():
		return self.id 

var zones = []
var last_zone = 0

var layout = [
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 2, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 2, 0, 0, 0,
	0, 0, 0, 1, 1, 1, 2, 0, 0, 0,
	0, 0, 0, 1, 1, 1, 2, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
]

var colors = [
	Color.RED,
	Color.BLUE,
	Color.GREEN,
	Color.GAINSBORO,
	Color.YELLOW,
	Color.VIOLET
]

func detect_zone(i: int, marked):
	var zone_val = layout[i]
	var x = i % 10
	var y = floor(i / 10.0)
	
	var remain_x = 10 - x
	var remain_y = 10 - y
	
	var size_x = 0
	var size_y = 0
	
	for xi in range(remain_x):
		var ii = i + xi
		var val = layout[ii]
		if val != zone_val:
			break
		size_x += 1
		
	for yi in range(remain_y):
		var ii = (y+yi) * 10 + x
		var val = layout[ii]
		if val != zone_val:
			break
		size_y += 1
		
	for xi in range(size_x):
		for yi in range(size_y):
			var ii = (y+yi) * 10 + x + xi
			marked[int(ii)] = true
	var zone = Zone.new()
	zone.id = zone_val
	zone.x = x
	zone.y = y
	zone.w = size_x
	zone.h = size_y
	return zone

func find_zones():
	var zones = []
	var marked = {}
	for i in len(layout):
		var val = layout[i]
		if val == 0:
			continue
		if marked.has(i):
			continue
		var zone = detect_zone(i, marked)
		zones.append(zone)
	return zones


func _ready():
	zones = find_zones()
	for zone in zones:
		print(zone.id, " ", zone.x, " ", zone.y)
	
func pos_to_zone(pos: Vector2):
	var p = pos + Vector2(5*W, 5*H)
	var px = floor(p.x / W)
	var py = floor(p.y / H)
	
	for zone in zones:
		#print("zone: ", zone.id, " x: ", zone.x, " y: ", zone.y)
		#print("px: ", px, " py: ", py)
		
		if px < zone.x:
			continue
		if px >= zone.x + zone.w:
			continue
		if py < zone.y:
			continue
		if py >= zone.y + zone.h:
			continue
		#print("px: ", px, " py: ", py, " zone: ", zone.id)
		return zone

func _physics_process(delta):
	if Engine.is_editor_hint():
		return
		
	if not Global.player:
		return
	if not Global.camera:
		return
		
	var zone = pos_to_zone(Global.player.global_position)
	if last_zone != zone.id:
		last_zone = zone.id
		var min_x = (zone.x - 5)  * W
		var min_y = (zone.y - 5) * H
		var w = (zone.w - 1) * W
		var h = (zone.h - 1) * H
		Global.camera.set_boundaries(min_x, min_y, w, h)
	

func _draw():
	zones = find_zones()
	if Engine.is_editor_hint():
	#if true:
		for i in range(-10, 10):
			for j in range(-10, 10):
				pass
				#draw_rect(Rect2(i*W + 1.0, j*H + 1.0, W - 2.0, H - 2.0), Color.DARK_RED, false, 2.0)
		#print(zones)
		for zone in zones:
			print(zone)
			var x = zone.x
			var y = zone.y
			var w = zone.w
			var h = zone.h
			var id = zone.id
			var off = 10 / 2
			var gx = (x-off) * W
			var gy = (y-off) * H
			var gw = w * W - 10
			var gh = h * H - 10
			draw_rect(Rect2(gx, gy, gw, gh), colors[id-1], false, 10.0)
