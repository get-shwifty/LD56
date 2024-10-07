extends Node2D

const ATTACK_LEFT_FOLLOW := 5.0
const POING_SPEEDX := 50.0
const POING_SPEEDY := 5.0
const POING_X1 := -300.0
const POING_H0 := -300.0
const POING_H1 := -300.0
const POING_H2 := -400.0
const POING_H3 := -50.0
const POINGL_MIN_X := -232.0
const POINGL_MAX_X := -60.0

var phase1 = [
	[0.0, "follow_left"],
]

func attack_left(phase, at_time):
	phase.append([at_time, "prepare_left"])
	phase.append([at_time+2.0, "attack_left"])
	phase.append([at_time+3.0, "follow_left"])

var time := 0.0
var left_target_y := POING_H0
enum { IDLE, FOLLOWING, PREPARING, ATTACKING }
var left_state := IDLE

func _ready():
	$Boss.modulate = Color(1.0, 1.0, 1.0, 0.0)
	Global.map = self
	Global.projectile_container = $Projectiles
	
	for i in range(100):
		attack_left(phase1, i*5.0 + 3.0)

func _physics_process(delta: float):
	time += delta
	if time > 8.0 and $Boss.modulate.a == 0.0:
		var tween = get_tree().create_tween()
		tween.tween_property($Boss, "modulate", Color.WHITE, 0.300)

	while not phase1.is_empty() and time >= phase1[0][0]:
		var action = phase1.pop_front()
		run(action[1])
	
	var player_position = %Player.position
	
	var left_target_follow = left_state != ATTACKING
	
	if left_target_follow:
		var target_x = clamp(player_position.x, POINGL_MIN_X, POINGL_MAX_X)
		var diff_x = target_x - $Boss/Left.position.x
		$Boss/Left.position.x += clamp(diff_x, -POING_SPEEDX*delta, +POING_SPEEDX*delta)
	
	var cur_target_y = 0.0
	match left_state:
		IDLE:
			cur_target_y = POING_H0
		FOLLOWING:
			cur_target_y = POING_H1
		PREPARING:
			cur_target_y = POING_H2
		ATTACKING:
			cur_target_y = POING_H3

	if left_target_follow:
		cur_target_y += player_position.y
	
	$Boss/Left.position.y =lerp($Boss/Left.position.y, cur_target_y, POING_SPEEDY*delta)
	
	shake($Boss/Left, time, left_state == PREPARING)
	front($Boss/Left, left_state == PREPARING or left_state == ATTACKING)

func run(action):
	match action:
		"idle_left":
			left_state = IDLE
		"prepare_left":
			left_state = PREPARING
		"attack_left":
			left_state = ATTACKING
		"follow_left":
			left_state = FOLLOWING

func shake(node: Node2D, time, do_shake):
	node.rotation = sin(time*20.0) * 0.05 if do_shake else 0.0

func front(node: Node2D, do_front):
	node.z_index = 10 if do_front else 0
