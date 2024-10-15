extends Node2D

@export var LIGHT: PackedScene = null
@export var scale_variance = 0.2
@export var front_scale = 3.0
@export var back_scale = 1.0

var light_node_back: Node2D = null
var light_node_front: Node2D = null

var tracked_nodes: Array[Node2D] = []
var tracked_light_back: Array[Node2D] = []
var tracked_light_front: Array[Node2D] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().physics_frame
	light_node_back = get_parent().get_node("CaverneBack/BackgroundVeil/Lights")
	light_node_front = get_parent().get_node("CaveFront/Lights")
	for child in get_children():
		self._add_track_node(child)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for i in range(len(tracked_nodes)):
		var pos = tracked_nodes[i].global_position
		tracked_light_back[i].global_position = pos
		tracked_light_front[i].global_position = pos

func _add_track_node(node: Node2D):
	
	var back_light = LIGHT.instantiate()
	back_light.scale = Vector2(back_scale, back_scale)
	light_node_back.add_child(back_light)
	
	var front_light = LIGHT.instantiate()
	front_light.scale = Vector2(front_scale, front_scale)
	light_node_front.add_child(front_light)
	
	node.back_light = back_light
	node.front_light = front_light
	
	tracked_light_back.append(back_light)
	tracked_light_front.append(front_light)
	
	tracked_nodes.append(node)
