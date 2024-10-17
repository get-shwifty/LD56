extends Node2D

var note: String = "A"
@export var speed = 50
@export var angle_spread = 20
@export var rotation_speed = 1.0
var angle = 0

@onready var light = $Light

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play(note)
	$Timer.start()
	$AnimationPlayer.play("fade")
	#angle = 90
	angle = randi_range(90-angle_spread, 90+angle_spread)
	angle = deg_to_rad(angle)
	#scale = Vector2(0.5, 0.5)
	light.on()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_position.y -= sin(angle) * delta * speed
	global_position.x += cos(angle) * delta * speed
	if $Timer.time_left < 0.5:
		rotate(sign(cos(angle)) * rotation_speed * delta)

func _on_timer_timeout():
	queue_free()
