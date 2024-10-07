extends Node2D

@onready var FOLLOWER = preload("res://src/world/follower.tscn")
@onready var FIREFLY = preload("res://src/firefly.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var paths = get_children()
	
	for path in paths:
		var follower = FOLLOWER.instantiate()
		path.add_child(follower)
		var firefly = FIREFLY.instantiate()
		firefly.target = path.get_child(0)
		var target = get_parent().get_node("Caverne").get_node("grotto").get_node("Fireflies")
		target.add_child(firefly)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
