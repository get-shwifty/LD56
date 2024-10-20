extends Node2D

@export var projectile: Resource = null

@export var time_offset = 0.0
@export var shadow_time = 1.0
@export var fall_time = 0.4
@export var total_time = 2.0

var speed = 0
var current_projectil: Node2D = null
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(time_offset).timeout
	spawn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not current_projectil: 
		return
	current_projectil.linear_velocity.y = speed
	var ratio = abs(current_projectil.position.y) / abs($Source.position.y)
	ratio = min(ratio, 0.8)
	$Shadow.animate_open(1.0 - ratio)
	

func spawn():
	$Shadow.scale = $Shadow.initial_scale
	$Shadow.modulate = Color(Color.WHITE, 0)
	var tween = get_tree().create_tween()
	tween.tween_property($Shadow, "modulate", Color(Color.WHITE, 1), shadow_time)
	await tween.finished
	current_projectil = projectile.instantiate()
	current_projectil.spawner = self
	$Source.add_child(current_projectil)
	current_projectil.position = Vector2.ZERO
	speed = abs($Source.position.y) / fall_time
	
func notify_projectil_end():
	current_projectil = null
	$Timer.wait_time = total_time - shadow_time - fall_time
	$Timer.start()

func _on_timer_timeout():
	spawn()
