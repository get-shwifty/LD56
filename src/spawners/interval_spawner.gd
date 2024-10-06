extends Node2D

@export var interval = 2 # seconds
@export var projectile: Resource = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = interval
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn():
	var proj = projectile.instantiate()
	proj.global_position = global_position
	Global.projectile_container.add_child(proj)

func _on_timer_timeout():
	spawn()
	$Timer.start()
