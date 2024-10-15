extends Node2D

@export var angle: float = 0
@export var distance: float = 100
@export var speed: float = 60
@export var pause: float = 0.3
@export var oscilation: float = 5
@export var light_amplitude = 0.1
@export var distance_at_1s_delay = 2000

@onready var light: Node2D = $Light
@onready var start_pos: Vector2 = global_position

var song_name = "light"
var counter = 0

func _ready():
	off()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	counter += delta
	$AnimatedSprite2D.position.y = sin(deg_to_rad(angle + 90)) * cos(counter * PI) * oscilation
	$AnimatedSprite2D.position.x = cos(deg_to_rad(angle + 90)) * cos(counter * PI) * oscilation
	var last_x = global_position.x
	
	var offset = walk_and_pause(counter, distance, speed, pause)
	global_position.x = start_pos.x + cos(deg_to_rad(angle)) * offset
	global_position.y = start_pos.y + sin(deg_to_rad(angle)) * offset

	light.animate(counter * PI)
	
	if last_x < global_position.x:
		$AnimatedSprite2D.scale.x = -1
	elif last_x > global_position.x:
		$AnimatedSprite2D.scale.x = 1

func on():
	light.on()
	$AnimatedSprite2D/GreenLight.show()
	$AnimatedSprite2D.play("on")
	
func off():
	light.off()
	$AnimatedSprite2D.play("off")
	$AnimatedSprite2D/GreenLight.hide()
	
func on_song(song: String):
	pass
		

func _on_reactive_component_activate():
	on()

func _on_reactive_component_deactivate():
	off()

func smoothstep_cos(t: float) -> float:
	var cos_val = cos(t)
	return smoothstep(-1, 1, cos_val)
	
func walk_and_pause(t: float, distance: float, speed: float, pause: float):
	var walk_time = distance / speed
	var interval_time = 2*walk_time + 2*pause
	
	var ratio = (t / interval_time)
	var time = (ratio - floor(ratio)) * interval_time
	
	if time < walk_time:
		return time / walk_time * distance
	if time < walk_time + pause:
		return distance
	if time < 2*walk_time + pause:
		var time2 = time - walk_time - pause
		return distance - (time2 / walk_time * distance)
	return 0
	
	
	
