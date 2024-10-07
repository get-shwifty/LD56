extends Node2D

const ATTACK_LEFT_FOLLOW := 5.0
const POING_SPEEDX := 50.0
const POING_SPEEDY := 5.0
const POING_SPEEDY_ATT := 1500.0
const POING_X1 := -300.0
const POING_H0 := -300.0
const POING_H1 := -300.0
const POING_H2 := -400.0
const POING_H3 := -65.0
const POINGL_MIN_X := -232.0
const POINGL_MAX_X := -60.0

var current_phase = 1

enum { FOLLOWING, PREPARING, ATTACKING }

var left_time := -2.0
var left_target_y := POING_H1
var left_state := FOLLOWING

var right_time := -2.0
var right_target_y := POING_H1
var right_state := FOLLOWING

func _ready():
	$Boss.modulate = Color(1.0, 1.0, 1.0, 0.0)
	Global.map = self
	Global.projectile_container = $Projectiles


func _physics_process(delta: float):
	if left_time < 0 and left_time + delta >= 0:
		var tween = get_tree().create_tween()
		tween.tween_property($Boss, "modulate", Color.WHITE, 0.300)

	left_time += delta
	right_time += delta
	
	var player_position = %Player.position
	if player_position.y > 20.0:
		%Player.set_collision_mask_value(1, true)
	
	# LEFT
	
	match left_state:
		FOLLOWING:
			if left_time > 3.0:
				left_state = PREPARING
		PREPARING:
			if left_time > 5.0:
				left_state = ATTACKING
				$Boss/Left/Overlaypoing.show()
				$Boss/Left/Kill.set_collision_mask_value(8, true)
		ATTACKING:
			if left_time > 5.5:
				left_state = FOLLOWING
				left_time = 0.0
				$Boss/Left/Overlaypoing.hide()
	
	var left_target_follow = left_state != ATTACKING
	
	if left_target_follow:
		var target_x = clamp(player_position.x, POINGL_MIN_X, POINGL_MAX_X)
		var diff_x = target_x - $Boss/Left.position.x
		$Boss/Left.position.x += clamp(diff_x, -POING_SPEEDX*delta, +POING_SPEEDX*delta)
	
	var cur_ltarget_y = 0.0
	match left_state:
		FOLLOWING:
			cur_ltarget_y = POING_H1
		PREPARING:
			cur_ltarget_y = POING_H2
		ATTACKING:
			cur_ltarget_y = POING_H3

	if left_target_follow:
		cur_ltarget_y += player_position.y
	
	if left_state == ATTACKING:
		$Boss/Left.position.y += POING_SPEEDY_ATT * delta
		if $Boss/Left.position.y > cur_ltarget_y:
			$Boss/Left.position.y = cur_ltarget_y
			$Boss/Left/Kill.set_collision_mask_value(8, false)
	else:
		$Boss/Left.position.y = lerp($Boss/Left.position.y, cur_ltarget_y, POING_SPEEDY*delta)
	
	shake($Boss/Left, left_time, left_state == PREPARING)
	front($Boss/Left, left_state == PREPARING or left_state == ATTACKING)

	# RIGHT
	
	match right_state:
		FOLLOWING:
			if right_time > 6.25:
				right_state = PREPARING
		PREPARING:
			if right_time > 7.75:
				right_state = ATTACKING
				$Boss/Right/Overlaypoing.show()
				$Boss/Right/Kill.set_collision_mask_value(8, true)
		ATTACKING:
			if right_time > 8.25:
				right_state = FOLLOWING
				right_time = 0.0
				$Boss/Right/Overlaypoing.hide()
	
	var right_target_follow = right_state != ATTACKING
	
	#if right_target_follow:
		#var target_x = clamp(player_position.x, POINGL_MIN_X, POINGL_MAX_X)
		#var diff_x = target_x - $Boss/Left.position.x
		#$Boss/Left.position.x += clamp(diff_x, -POING_SPEEDX*delta, +POING_SPEEDX*delta)
	
	var cur_rtarget_y = 0.0
	match right_state:
		FOLLOWING:
			cur_rtarget_y = POING_H1
		PREPARING:
			cur_rtarget_y = POING_H2
		ATTACKING:
			cur_rtarget_y = POING_H3

	if right_target_follow:
		cur_rtarget_y += player_position.y
	
	if right_state == ATTACKING:
		$Boss/Right.position.y += POING_SPEEDY_ATT * delta
		if $Boss/Right.position.y > cur_rtarget_y:
			$Boss/Right.position.y = cur_rtarget_y
			$Boss/Right/Kill.set_collision_mask_value(8, false)
	else:
		$Boss/Right.position.y = lerp($Boss/Right.position.y, cur_rtarget_y, POING_SPEEDY*delta)
	
	shake($Boss/Right, right_time, right_state == PREPARING)
	front($Boss/Right, right_state == PREPARING or right_state == ATTACKING)

func shake(node: Node2D, time, do_shake):
	node.rotation = sin(time*20.0) * 0.05 if do_shake else 0.0

func front(node: Node2D, do_front):
	node.z_index = 10 if do_front else 0


func _on_left_kill_body_entered(body: Node2D) -> void:
	put_player_down()

func _on_right_kill_body_entered(body: Node2D) -> void:
	put_player_down()
	
func put_player_down():
	%Player.set_collision_mask_value(1, false)


func _on_panier_body_entered(body: Node2D) -> void:
	current_phase = 2
	$Boss/AnimationPlayer.play("fall")
